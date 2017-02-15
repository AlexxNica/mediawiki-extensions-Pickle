<?php

namespace Pickle;

/**
 * Test console view
 *
 * @ingroup Extensions
 */
class ConsoleView {

	/**
	 * Get Lua question
	 */
	public static function getQuestion( \Title $title ) {

		// check if there is a subpage to invoke
		$invokeStrategy = InvokeSubpageStrategies::getInstance()->find( $title );
		if ( $invokeStrategy === null ) {
			return null;
		}

		// check if this page is the subpage itself
		$baseTitle = $title->getBaseTitle();
		if ( $baseTitle !== null ) {
			$baseInvokeStrategy = InvokeSubpageStrategies::getInstance()->find( $baseTitle );
			if ( $baseInvokeStrategy !== null ) {
				$maybePageMsg = $invokeStrategy->getSubpagePrefixedText( $baseTitle );
				if ( ! $maybePageMsg->isDisabled() ) {
					$maybePage = $maybePageMsg->plain();
					if ( $maybePage == $title->getPrefixedText() ) {
						return $invokeStrategy->getTesterQuestion( $title );
					}
				}
			}
		}

		// still missing the question-part for the console call?
		return $invokeStrategy->getTesteeQuestion( $title );
	}

	/**
	 * Build the view
	 * This isn't really part of a normal MVC design pattern, it will only build a minimal view.
	 *
	 * @param EditPage $editor
	 * @param OutputPage $output
	 *
	 * @return boolean outcome of the call
	 */
	public static function build( \EditPage &$editor, \OutputPage $output ) {

		// get the title of current page
		$title = $editor->getTitle();

		// If there is no title or content model is wrong, then bail out
		if ( $title === null || $title->getContentModel() !== CONTENT_MODEL_SCRIBUNTO ) {
			return true;
		}

		// get the question to be used for querrying the console
		$question = self::getQuestion( $title );
		if ( $question === null ) {
			return true;
		}

		// wrap it up for use in the browser
		$output->addScript(
			\ResourceLoader::makeInlineScript(
				\ResourceLoader::makeMessageSetScript( [ 'pickle-console-question' => $question ] )
			)
		);

		// and the stuff to actually do it all
		$output->addModules( 'ext.pickle.console' );

		// add container for form
		$editor->editFormTextAfterTools .=
			'<div id="mw-pickle-console"></div>';

		return true;
	}

	/**
	 * Add a view for test console
	 *
	 * @param EditPage $editor
	 * @param any $checkboxes is neglected
	 * @param any $tabindex is neglected
	 */
	public static function onEditPageBeforeEditChecks( \EditPage &$editor, &$checkboxes, &$tabindex ) {
		$output = \RequestContext::getMain()->getOutput();
		return self::build( $editor, $output );
	}

	/**
	 * Add a view for test console
	 *
	 * @param EditPage $editor
	 * @param OutputPage $output
	 */
	public static function onShowReadOnlyFormInitial( \EditPage $editor, \OutputPage $output ) {
		return self::build( $editor, $output );
	}

	/**
	 * @todo This doc section must be wrong
	 * @see \Pickle\IObserver::getName()
	 */
	public function makeForm() {
		$editor->editFormTextAfterTools .= '<div id="mw-scribunto-console"></div>';
		return self::$instance;
	}
}
