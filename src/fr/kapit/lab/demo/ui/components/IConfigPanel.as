package fr.kapit.lab.demo.ui.components
{
import fr.kapit.lab.demo.model.ApplicationModel;

/**
 * Defines the interface of each configuration panel.
 */
public interface IConfigPanel
{
	/**
	 * Reference to the current application model.
	 */
	function get appModel():ApplicationModel;
	/** @private */
	function set appModel(objValue:ApplicationModel):void;
}
}