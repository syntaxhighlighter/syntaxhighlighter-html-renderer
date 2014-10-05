`$ = require('cheerio')` if typeof $ is 'undefined'

chai = require 'chai'
fs = require 'fs'

parser = require 'parser'
{Renderer} = require '..'
expect = chai.expect

REGEX_LIST = [
  {regex: /hello|world/g, css: 'greeting'}
  {regex: /\w+/g, css: 'word'}
]

CODE = fs.readFileSync "#{__dirname}/fixture.js", 'utf8'

render = (code, opts = {}) ->
  matches = parser.parse code, opts.regexList or REGEX_LIST
  renderer = new Renderer code, matches, opts
  renderer.render()

describe 'html-renderer', ->
  element = null

  itHasElements = ({gutter, lineCount, firstLine, highlight} = {}) ->
    firstLine ?= 1

    describe 'gutter', ->
      if gutter
        it 'is present', -> expect($ 'td.gutter', element).to.have.length 1
        it "has #{lineCount} lines", -> expect($ 'td.gutter > .line', element).to.have.length lineCount
        it "starts at line #{firstLine}", -> expect($($('td.gutter > .line', element)[0]).hasClass 'number' + firstLine).to.be.true

        for lineNumber in highlight or []
          it "has line #{lineNumber} highlighted", ->
            expect($("td.gutter > .line.number#{lineNumber}", element).hasClass 'highlighted').to.be.true

      else
        it 'is not present', -> expect($ 'td.gutter', element).to.have.length 0

    describe 'code', ->
      it 'is present', -> expect($ 'td.code', element).to.have.length 1
      it "has #{lineCount} lines", -> expect($ 'td.code > .container > .line', element).to.have.length lineCount
      it "starts at line #{firstLine}", -> expect($($('td.code > .container > .line', element)[0]).hasClass 'number' + firstLine).to.be.true

  describe 'rendering with default options', ->
    before -> element = $ render CODE, {}
    itHasElements gutter: yes, lineCount: 14

  describe 'rendering with options', ->
    describe 'without gutter', ->
      before -> element = $ render CODE, gutter: false
      itHasElements gutter: no, lineCount: 14

    describe 'custom first line', ->
      before -> element = $ render CODE, firstLine: 10
      itHasElements gutter: yes, lineCount: 14, firstLine: 10

    describe 'line highlighting', ->
      describe 'one line', ->
        before -> element = $ render CODE, highlight: 1
        itHasElements gutter: yes, lineCount: 14, highlight: [1]

      describe 'multiple lines', ->
        before -> element = $ render CODE, highlight: ['3', '4']
        itHasElements gutter: yes, lineCount: 14, highlight: [3, 4]

    describe 'processing URLs', ->
      before -> element = $ render CODE, autoLinks: yes, regexList: []
      itHasElements gutter: yes, lineCount: 14
      it 'has URL on line 3', ->
        expect($ "td.code > .container > .line.number3 > .plain > a", element).to.have.length 1
