chai = require 'chai'
parser = require 'syntaxhighlighter-parser'
{Renderer} = require '..'
expect = chai.expect

`$ = require('cheerio')` if typeof $ is 'undefined'

REGEX_LIST = [
  {regex: /hello|world/g, css: 'greeting'}
  {regex: /\w+/g, css: 'word'}
]

describe 'syntaxhighlighter-html-renderer', ->
  describe 'new brush', ->
    element = null

    before ->
      code = "hello all world"
      matches = parser.parse code, REGEX_LIST
      renderer = new Renderer code, matches, {}
      element = $ renderer.render()

    describe 'instance', ->
      it '...', ->
        console.log element
