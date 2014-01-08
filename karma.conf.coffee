module.exports = (config) ->
  config.set
    frameworks: ['mocha', 'chai', 'browserify']
    browsers: if process.env.TRAVIS then ['Firefox'] else ['Chrome']

    preprocessors:
      'test/**/spec.coffee': ['coffee', 'browserify']

    browserify:
      transform: ['coffeeify']
      extensions: ['.coffee']
      noParse: ['cheerio']
      watch: true
      debug: true

    files: [
      'bower_components/jquery/jquery.min.js'
      'test/**/spec.coffee'
    ]
