# Rodux Changelog

## Unreleased Changes

## 3.0.0 (2021-03-25)
* Revise error reporting logic; restore default semantics from version 1.x ([#61](https://github.com/Roblox/rodux/pull/61)).

## 2.0.0 (2021-03-17)
* Introduce error handling to catch and report errors during reducers ([#60](https://github.com/Roblox/rodux/pull/60)).

## 1.1.0 (2021-01-04)
* Added color schemes for documentation based on user preference ([#56](https://github.com/Roblox/rodux/pull/56)).
* Added `makeActionCreator` utility for common action creator pattern ([#35](https://github.com/Roblox/rodux/pull/35))

## 1.0.0 (2019-09-18)
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

## Public Release (2017-12-13)
* Initial release!
