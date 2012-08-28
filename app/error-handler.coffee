module.exports = (app) ->

  # error handling
  app.use (req, res, next) ->
    # respond with html page
    if req.accepts('html')
      res.status 404
      app.locals.url = req.url
      res.render '404'
      return

    # respond with json
    if req.accepts('json')
      res.send { error: 'Not found' }
      return

    # default to plain-text. send()
    res.type('txt').send('Not found')

  app.use (err, req, res, next) ->
    # we may use properties of the error object
    # here and next(err) appropriately, or if
    # we possibly recovered from the error, simply next().
    res.status(err.status or 500)
    app.locals.error = err
    res.render '500'