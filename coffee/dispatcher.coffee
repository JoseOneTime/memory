{Promise} = require 'es6-promise'

callbacks = promises = []

class Dispatcher
	register: (callback) =>
		callbacks.push callback
		callbacks.length - 1

	dispatch: (payload) =>
		resolves = rejects = []
		promises = callbacks.map (_, i) ->
			new Promise (resolve, reject) ->
				resolves[i] = resolve
				rejects[i] = reject
		callbacks.forEach (callback, i) ->
			Promise.resolve(callback(payload)).then(
				-> resolves[i] payload,
				-> rejects[i] new Error('Dispatcher callback unsuccessful')
			)
		promises = []

	waitFor: (promiseIndexes, callback) ->
		selectedPromises = promiseIndexes.map (index) ->
			promises[index]
		Promise.all(selectedPromises).then callback

module.exports = Dispatcher
