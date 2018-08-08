# Rodux Changelog

## Current master
* Added `combineReducers` utility, mirroring Redux's ([#9](https://github.com/Roblox/rodux/pull/9))
* Added `createReducer` utility, similar to `redux-create-reducer` ([#10](https://github.com/Roblox/rodux/pull/10))
* `type` is now required as a field on all actions
* Introduced middleware ([#13](https://github.com/Roblox/rodux/pull/13))
	* Thunks are no longer enabled by default, use `Rodux.thunkMiddleware` to add them back.
	* Added `Rodux.loggerMiddleware` as a simple debugger
	* The middleware API changed in [#29](https://github.com/Roblox/rodux/pull/29) in a backwards-incompatible way!
		* Middleware now run left-to-right instead of right-to-left!
* Errors thrown in `changed` event now have correct stack traces ([#27](https://github.com/Roblox/rodux/pull/27))
* Fixed `createReducer` having incorrect behavior with `nil` state values ([#33](https://github.com/Roblox/rodux/pull/33))

## Public Release (December 13, 2017)
* Initial release!