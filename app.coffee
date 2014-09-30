# Module dependencies
express = require 'express'
app = express()

# Set view template engine
app.set 'views', __dirname + '/app/views'
app.set 'view engine', 'jade'

# Common settings
#app.use(express.favicon(__dirname + '/../assets/img/favicon.ico')) # seems to set cache time to 1 day
app.use express.bodyParser() # should be above methodOverride
app.use express.methodOverride()

# Development settings
if 'development' is app.get('env')
  app.use express.logger('dev')
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })
  app.locals.pretty = true
  app.locals.debug = false

# Staging settings
if 'staging' is app.get('env')
  # basic auth for staging
  authorize = (username, password) ->
    return 'test' is username and 'showmepreview' is password;
  app.use express.basicAuth(authorize)

# Assets manager
app.use require('connect-assets')()

# Static assets
if 'development' is app.get('env')
  app.use express.static(__dirname + '/assets') # should be above session for speed

if 'production' is app.get('env') or 'staging' is app.get('env')
  app.use express.compress()
  app.use express.static(__dirname + '/assets', { maxAge: 31557600000 })
  app.use express.static(__dirname + '/builtAssets', { maxAge: 31557600000 })

# Routes
app.get '/', (req, res) ->
  res.render 'index'

app.get '/cv', (req, res) ->
  res.render 'cv'

app.get '/py101', (req, res) ->
  res.redirect '/python101/day2_data_structures.html'

app.get '/py101_exs', (req, res) ->
  res.redirect '/python101/day2_data_structures_exercises.ipynb'

app.get '/ccs14', (req, res) ->
  res.redirect '//bmpvieira.github.io/ccs14'

app.get '/seminar14', (req, res) ->
  res.redirect '//bmpvieira.github.io/seminar14'

app.get '/labjolly14a', (req, res) ->
  res.redirect '//bmpvieira.github.io/labjolly14a'

app.get '/cw14', (req, res) ->
  res.redirect '//bmpvieira.github.io/cw14'

app.get '/allbio14', (req, res) ->
  res.redirect '//bmpvieira.github.io/allbio14'

app.get '/assembly-talk', (req, res) ->
  res.redirect '//bmpvieira.github.io/stuff'

app.get '/assembly-practical', (req, res) ->
  res.redirect 'https://gist.github.com/bmpvieira/d5f0fd6b0fd13ef8c8a4'

# Custom error messages for production
if app.settings.env is 'production'
  require('./app/error-handler')(app)

# Start listening on <port>
port = process.argv[2] or process.env.PORT or 3000
app.listen port, ->
  console.log('Express app started on port ' + port)
