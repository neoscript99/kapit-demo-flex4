package fr.kapit.lab.demo.model
{
import flash.events.Event;
import flash.events.EventDispatcher;

import fr.kapit.actionscript.system.IDisposable;
import fr.kapit.diagrammer.Diagrammer;

/**
 * Dispatched when a visualizer/diagrammer component is registered to
 * the application model.
 */
[Event(name="datavizComponentAssigned", type="flash.events.Event")]


[Bindable]
/**
 * Application model (seems obvious).
 */
public class ApplicationModel extends EventDispatcher implements IDisposable
{
	/**
	 * Abstraction to control the diagrammer instance.
	 * An instance is created when a diagrammer component is registered
	 * to the application model.
	 *
	 * @see #diagrammer
	 */
	protected var _diagrammerModel:DiagrammerModel = null;


	/**
	 * Constructor.
	 */
	public function ApplicationModel()
	{
	}


	/**
	 * Explicit references clean up.
	 * The current instance may not be considered usable there after, so
	 * one should call the <code>dispose()</code> method before an
	 * object gets "destroyed".
	 * <p>
	 * The <code>recursive</code> parameter is intended to be used
	 * on composite classes : for example, a collection may try to apply
	 * <code>dispose()</code> on each of its elements.
	 * </p>
	 *
	 * @see http://en.wikipedia.org/wiki/Dispose
	 *
	 * @param recursive
	 * 		if set to <code>true</code> then the clean up is recusively done.
	 */
	public function dispose(recursive:Boolean=false):void
	{
		if (null != diagrammerModel)
		{
			diagrammerModel.dispose(recursive);
			_diagrammerModel = null;
		}
	}


	/**
	 * Diagrammer wrapper.
	 */
	[Bindable(event="diagrammerModelUpdated")]
	public function get diagrammerModel():DiagrammerModel
	{
		return _diagrammerModel;
	}


	/**
	 * Diagrammer component.
	 * Should be Initialized as the application starts.
	 */
	public function get diagrammer():Diagrammer
	{
		if (null == diagrammerModel)
			return null;
		return diagrammerModel.diagrammer;
	}
	/** @private */
	public function set diagrammer(value:Diagrammer):void
	{
		if (value == diagrammer)
			return;

		if (null != diagrammerModel)
		{
			diagrammerModel.dispose(false);
			_diagrammerModel = null;
		}
		if (null != value)
		{
			_diagrammerModel = new DiagrammerModel(value);
			dispatchEvent(new Event("diagrammerModelUpdated"));
		}

		dispatchEvent(new Event("datavizComponentAssigned"));
	}

}
}