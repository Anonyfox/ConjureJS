Conjure = exports? and exports or @Conjure = {}

# modifies Object.prototype directly to add magical convenience methods
# for more power, specify a load path where your modules exist
Conjure.activate = () ->

  # inject a trait module by calling its `enchant` method
  # thus: the "trait" must be a module which has a public "enchant" method
  Object.prototype.enchant = (traits) ->
    traits = [traits] unless traits?.length
    trait.enchant this for trait in traits
    return this

  # deep clone an object
  Object.defineProperty Object.prototype, "mirror",
    value: -> JSON.parse(JSON.stringify(this))
    enumerable: false

  a = {}
  console.log a.enchant
  console.log a.mirror

  # inject all members of the given objects into this one
  # {a:1}.absorb [ {b:2}, {c:3} ]  # => {a:1, b:2, c:3}
  Object.prototype.absorb = (objects) ->
    objects = [objects] unless objects?.length
    for o in objects
      this[k] or= v for k,v of o
    return this

  # returns a list of all keys of the object
  Object.prototype.dispel = ->
    Object.keys(this)

  # returns conjure itself for easy initialization and chaining
  return this

# Namespaced Modules !
# https://github.com/jashkenas/coffee-script/wiki/FAQ#-codenamespace--target-name-block----target-name-block--if-typeof-exports-isnt-undefined-then-exports-else-window-arguments-if-argumentslength--3--top-----target--target--targetitem-or--for-item-in-namesplit---block-target-top-usagenamespace-helloworld-exports-----exports-is-where-you-attach-namespace-members--exportshi----consolelog-hi-worldnamespace-sayhello-exports-top-----top-is-a-reference-to-the-main-namespace--exportsfn----tophelloworldhisayhellofn---prints-hi-world
Conjure.grimoire = ->

# defines a memoized function
# addspell = Conjure.spell (a,b) -> a + b
#
# The spell gets more efficient the more you use it.
Conjure.spell = (fn) ->
  cache = {}
  (args...) ->
    key = JSON.stringify(args)
    if cache[key] then cache[key] else cache[key] = fn(args...)

# aura = Conjure.aura (a,b) -> a + b
# aura(1,2) # => 3
# aura(3) #=> 5
# aura.b = 10
# aura() #=> 13
#
# An "aura" means a kind of heavyweight workhorse-function.
# you initialize it with a signature and your wanted function,
# and simply use it like a usual function. However, an aura
# can be reused to a greater extend than an usual function !
#
# After you declared it, you can call it without repeating
# your function arguments again and again, they're memoized.
# You can override all the arguments by calling this function
# with new values, and even just partly argument lists.
#
# Even more crazy: you can set a specific parameter of the function
# explicitly to a new value! Therefore the exact argument name
# from the function initalization is used.
#
# When you want to use a "spell" for a _pure_ function, an "aura"
# is appropriate for performing functions with side-effects which
# are called more than once with slightly modified arguments but
# similar behavior.
Conjure.aura = (fn) ->
  # fn_values = Array.prototype.slice.call( arguments, 0 )
  signature = getArgumentNames fn
  afn = (args...) ->
    afn[signature[i]] = args[i] for i in [0 ... args.length]
    fn (afn[p] for p in signature)...
  return afn

### private helpers ###

getArgumentNames = (fn) ->
  fn.toString()
  .replace(/((\/\/.*$)|(\/\*[\s\S]*?\*\/)|(\s))/mg,'')
  .match(/^function\s*[^\(]*\(\s*([^\)]*)\)/m)[1]
  .split(/,/)

isString = (x) ->
  typeof x is 'string' or x instanceof String

# special functions
# sorcery ?
# instant ?
# counter ?
# buff ?
