<?php

namespace Pickle;

use MediaWiki\Logger\LoggerFactory;

/**
 * Indicator base
 * Encapsulates the abstract base class indicator as an adapter.
 *
 * @ingroup Extensions
 */
abstract class AIndicator {

	use TNamedStrategy;

	protected $opts;

	/**
	 * Clone the opts
	 *
	 * @return array
	 */
	public function cloneOpts() {
		return array_merge( [], $this->opts );
	}

	/**
	 * Make a page status indicator link given status and url
	 *
	 * @param string $url to the internal or external page
	 * @return Html|null
	 */
	public function makeLink( $url, $lang = null ) {

		// Get the message containing the text to use for the link
		// @message pickle-test-text-good
		// @message pickle-test-text-pending
		// @message pickle-test-text-fail
		// @message pickle-test-text-missing
		// @message pickle-test-text-unknown
		$msg = wfMessage( $this->getMessageKey() );
		$msg = $lang === null ? $msg->inContentLanguage() : $msg->inLanguage( $lang );
		if ( $msg->isDisabled() ) {
			LoggerFactory::getInstance( 'Pickle' )->debug( 'Found disabled message: {key}', [
				'key' => $this->getMessageKey(),
				'method' => __METHOD__
			] );
			return null;
		}

		// Build a link for the page status indicator
		$elem = \Html::rawElement(
			'a',
			[
				'href' => $url,
				'target' => '_blank',
				'class' => [ $this->getClassKey(), $this->getKey(), $this->getIcon() ]
			],
			$msg->parse()
		);

		return $elem;
	}

	/**
	 * Make a page status indicator note given status
	 *
	 * @param string $status representing the state
	 * @return Html|null
	 */
	public function makeNote( $lang = null ) {

		// Get the message containing the text to use for the link
		// @message pickle-test-text-good
		// @message pickle-test-text-pending
		// @message pickle-test-text-fail
		// @message pickle-test-text-missing
		// @message pickle-test-text-unknown
		$msg = wfMessage( $this->getMessageKey() );
		$msg = $lang === null ? $msg->inContentLanguage() : $msg->inLanguage( $lang );
		if ( $msg->isDisabled() ) {
			LoggerFactory::getInstance( 'Pickle' )->debug( 'Found disabled message: {key}', [
				'key' => $this->getMessageKey(),
				'method' => __METHOD__
			] );
			return null;
		}

		// Build a link for the page status indicator
		$elem = \Html::rawElement(
			'span',
			[
				'class' => [ $this->getClassKey(), $this->getKey(), $this->getIcon() ]
			],
			$msg->parse()
		);

		return $elem;
	}

	/**
	 * Get the key
	 *
	 * @return string
	 */
	public function getKey() {
		return $this->getClassKey() . '-' . $this->opts['name'];
	}

	/**
	 * Get the icon
	 *
	 * @return string
	 */
	public function getIcon() {
		return 'mw-speclink-icon-' . $this->opts['icon'];
	}

	/**
	 * Get the messagekey
	 *
	 * @return string
	 */
	public function getMessageKey() {
		return 'pickle-test-text-' . $this->opts['name'];
	}

	/**
	 * Get the class key
	 *
	 * @return string
	 */
	public function getClassKey() {
		return 'mw-speclink';
	}

	/**
	 * Add a new track indicator
	 *
	 * @param \Title target for the indicator
	 * @param \ParserOutput where the indicator should be added
	 *
	 * @return Message
	 */
	public function addIndicator( \Title $title = null, \ParserOutput &$parserOutput ) {
		$elem = null;

		if ( $title === null ) {
			$elem = $this->makeNote();
		} else {
			$elem = $this->makeLink( $title->getLocalURL() );
		}

		if ( $elem !== null ) {
			$res = $parserOutput->setIndicator( $this->getClassKey(), $elem );
			$parserOutput->addModuleStyles( [ 'ext.pickle.default', 'ext.pickle.indicator.icon' ] );
		}

		return $elem;
	}
}
