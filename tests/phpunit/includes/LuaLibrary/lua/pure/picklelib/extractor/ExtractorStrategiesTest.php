<?php

namespace Pickle\Test;

use Scribunto_LuaEngineTestBase;

/**
 * @group Pickle
 *
 * @license GNU GPL v2+
 *
 * @author John Erling Blad < jeblad@gmail.com >
 */
class ExtractorStrategiesTest extends Scribunto_LuaEngineTestBase {

	protected static $moduleName = 'ExtractorStrategiesTest';

	function getTestModules() {
		return parent::getTestModules() + [
			'ExtractorStrategiesTest' => __DIR__ . '/ExtractorStrategiesTest.lua'
		];
	}
}
