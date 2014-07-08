module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-karma'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-mocha-cli'

  grunt.config.init
    karma:
      options: configFile: 'karma.conf.coffee'
      singleRun: singleRun: true
      background: background: true

    mochacli:
      options:
        'colors': not process.env.TRAVIS
        'check-leaks': true
        'compilers': ['coffee:coffee-script/register']
        'recursive': yes
        'reporter': 'spec'
        'ui': 'bdd'
      test: ['test/**/*.spec.coffee']

    watch:
      options: spawn: false

      lib:
        files: ['lib/**/*.js', 'test/**/*.spec.coffee']
        tasks: ['mochacli', 'karma:background:run']

  grunt.registerTask 'test', ['mochacli', 'karma:singleRun']
  grunt.registerTask 'dev', ['karma:background', 'watch']
