<?php

if ( function_exists( 'wfLoadExtension' ) ) {
	wfLoadExtension( 'Pickle', __DIR__ . '/extension.json' );
	// Keep i18n globals so mergeMessageFileList.php doesn't break
	$wgMessagesDirs['Pickle'] = __DIR__ . '/i18n';

	$wgExtensionMessagesFiles['SpecMagic'] = __DIR__ . '/Pickle.i18n.magic.php';
	wfWarn(
		'Deprecated PHP entry point used for Pickle extension. Please use wfLoadExtension ' .
		'instead, see https://www.mediawiki.org/wiki/Extension_registration for more details.'
	);
	return true;
} else {
	die( 'This version of the Pickle extension requires MediaWiki 1.25+' );
}
