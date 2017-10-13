package fr.kapit.lab.demo.ui.components.properties
{
import fr.kapit.lab.demo.ui.components.IConfigPanel;

public interface IPropertiesConfigPanel extends IConfigPanel
{
	/**
	 * Method invoked to update the panel according to state of
	 * the data visualization component (selection, style...).
	 */
	function synchronize():void;
}
}