Port Authority
==============

Npm inspired package management for Ruby.
Felt like it was worth playing with the idea after I commented about it https://twitter.com/josh_cheek/status/564560602828242944

Yes, [I am squatting](https://rubygems.org/gems/port_authority).
If I haven't done anything with this in like a year, and you want the name,
let me know and I'll probably give it to you.


Notes I wrote down
------------------

* charter.json instead of gemspec
* file exports whatever it provides
* file imports whatever it needs
* dependencies only go one way (it receives nothing from parent environment)

```ruby
# file: myfile.rb
WrapExpressions = import('seeing_is_believing')::WrapExpressions
...
```

```ruby
# file: seeing_is_believing.rb
# toplevel object here is a PortAuthority::Dock, a place to import and export
WrapExpressions = import 'seeing_is_believing/wrap_expressions'

# can export_class, export_object, export_function, export_module
# function and object will actually be implemented as modules to support namespacing
export_class do
  def initialize(...)
  end
end
```

* May facilitate shared state by providing a `global_state` object, which is scoped to that file
  (all dependencies point down, it cannot access a parent's global state. if the parent wants this, it will need to explicitly give access to that state)
  the structure of this object would be declared in charter.json
* Your code is loaded in a dock named after your gem and the file it's within.
* You cannot assume your is in the file you write it in. Your code is not in that file, your code is in the matrix. Maybe it's a file,
  maybe it's being read in and evaled somewhere, maybe it's being completely rewritten so that its entire definition is contained within a single file,
  intending to be executed in a very different context. You don't know, so don't make that assumption.
* I generally like the idea that you must declare all files you depend on.
* Your gem must declare all of your files, and each file's dependencies in charter.json
* A file can only depend on other files in its repository if they are at the same level of nesting or deeper. It cannot depend on a file in a parent directory.
  I kind of like the idea that it can't depend on its siblings, either. The parent would then have to wire any siblings together.
  Or maybe that's just one way to enforce that you can't have circular dependencies, and if I have you declare all dependencies,
  then I can enforce it that way, without adding the overhead of all those directories and indirection.
* To publish your package, you must pass linting
  * ensures your lib adds no constants to anything reachable from `::Object` via constant resolution, unless you've declared them in the charter section titled "pollution"
  * same thing for methods (ie guerilla patching will be painful)
  * checks for access to global objects (constant resolution from Object, and $vars)
  * will come with its own code coverage tool (SimpleCov is designed badly enough that it's not worth it for me to try to salvage it -- I've already lost hours trying to get it to work with SiB)
    Your code must exceed 95% test coverage to be publishable.
* a gem to provide rubygems interop
* Support searching by license, author, percent of test coverage, number of dependencies, number of lines of code, specific dependencies (ie filter for just packages that deal with sockets, or exclude packages that access global state)
* Fun thought: could totally support coffeescript style literate programming
* No need for onload/onunload callbacks, b/c all state will be stored in the declared `global_state` object.
  So your code can disappear as references are lost, and reappear as they are re-required, with no worry about getting into an inconsistent state.
  This saves the developer from having to deal with the complexity of managing their state, exposes the state, and allows the code to be safely garbage collected and reloaded.
* Source code is not included in the package. Rather, the charter declares a git repo and sha, the code is downloaded on demand. The site to host / search these just deals with charter.json
* Charter can specify viable ruby versions
* files will not be added to the load path, so organize your files how you like, and global load times will not be affected.
* I think I like NPM's scripts idea (scripts.test, scripts.build), could allow us to get away from Rake (ill-equipped for command-line apps)
  and Thor (poorly designed with a CLI interface that is either inconsistent or deeply confusing, not sure which)
* charter.json allows you to specify dirs for source, data, tests, and executables.
  I haven't considered yet how to deal with extensions as I'm very ignorant about these domains.
