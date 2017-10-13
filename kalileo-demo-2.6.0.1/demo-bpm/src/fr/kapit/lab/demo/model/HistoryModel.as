package fr.kapit.lab.demo.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import fr.kapit.actionscript.system.IDisposable;
	import fr.kapit.diagrammer.Diagrammer;
	import fr.kapit.diagrammer.actions.RedoAction;
	import fr.kapit.diagrammer.actions.UndoAction;
	import fr.kapit.lab.demo.models.IHistoryModel;
	import fr.kapit.visualizer.events.VisualizerEvent;
	
	public class HistoryModel extends EventDispatcher implements IDisposable, IHistoryModel
	{
		/**
		 * Current instance of the diagrammer component.
		 */
		protected var _diagrammer:Diagrammer;
		
		/**
		 * Indicates if there is actions to undo 
		 */		
		protected var _canUndo:Boolean = false;
		[Bindable(event="UndoRedoTasksChanged")]
		public function get canUndo():Boolean
		{
			return _canUndo;
		}
		
		/**
		 * Indicates if there is actions to redo 
		 */
		protected var _canRedo:Boolean = false;
		[Bindable(event="UndoRedoTasksChanged")]
		public function get canRedo():Boolean
		{
			return _canRedo;
		}
		
		public function HistoryModel(objDiagrammer:Diagrammer)
		{
			_diagrammer = objDiagrammer;
			addListeners();
		}
		
		/**
		 * Explicit references clean up.
		 * The current instance may not be considered usable there after, so
		 * one should call the <code>dispose()</code> method before an
		 * object gets "destroyed".
		 * <p>
		 * The <code>bRecursive</code> parameter is intended to be used
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
			if (null != _diagrammer)
			{
				removeListeners();
				_diagrammer = null;
			}
		}
		
		/**
		 * Adds event listeners to the current diagrammer instance.
		 */
		protected function addListeners():void
		{
			_diagrammer.addEventListener(VisualizerEvent.GRAPH_PANNED, checkUndoRedoTasks);
			_diagrammer.addEventListener(VisualizerEvent.GRAPH_ZOOMED, checkUndoRedoTasks);
			_diagrammer.addEventListener(VisualizerEvent.GRAPH_FITTED, checkUndoRedoTasks);
			_diagrammer.addEventListener(VisualizerEvent.ELEMENTS_CREATED, checkUndoRedoTasks);
			_diagrammer.addEventListener(VisualizerEvent.ELEMENTS_DELETED, checkUndoRedoTasks);
			_diagrammer.addEventListener(VisualizerEvent.ELEMENTS_DRAG_STARTED, checkUndoRedoTasks);
			_diagrammer.addEventListener(VisualizerEvent.ELEMENTS_DRAGGING, checkUndoRedoTasks);
			_diagrammer.addEventListener(VisualizerEvent.ELEMENTS_DRAG_FINISHED, checkUndoRedoTasks);
			_diagrammer.addEventListener(VisualizerEvent.ELEMENTS_SELECTION_CHANGED, checkUndoRedoTasks);
			_diagrammer.addEventListener(VisualizerEvent.ELEMENTS_PROPERTY_CHANGED, checkUndoRedoTasks);
			_diagrammer.addEventListener(VisualizerEvent.ELEMENTS_EXPANDED_COLLAPSED, checkUndoRedoTasks);
			_diagrammer.addEventListener(VisualizerEvent.ELEMENT_CLICKED, checkUndoRedoTasks);
			_diagrammer.addEventListener(VisualizerEvent.ELEMENT_ROLL_OVER, checkUndoRedoTasks);
			_diagrammer.addEventListener(VisualizerEvent.ELEMENT_ROLL_OUT, checkUndoRedoTasks);
		}
		/**
		 * Removes event listeners from the diagrammer instance.
		 */
		protected function removeListeners():void
		{
			_diagrammer.removeEventListener(VisualizerEvent.GRAPH_PANNED, checkUndoRedoTasks);
			_diagrammer.removeEventListener(VisualizerEvent.GRAPH_ZOOMED, checkUndoRedoTasks);
			_diagrammer.removeEventListener(VisualizerEvent.GRAPH_FITTED, checkUndoRedoTasks);
			_diagrammer.removeEventListener(VisualizerEvent.ELEMENTS_CREATED, checkUndoRedoTasks);
			_diagrammer.removeEventListener(VisualizerEvent.ELEMENTS_DELETED, checkUndoRedoTasks);
			_diagrammer.removeEventListener(VisualizerEvent.ELEMENTS_DRAG_STARTED, checkUndoRedoTasks);
			_diagrammer.removeEventListener(VisualizerEvent.ELEMENTS_DRAGGING, checkUndoRedoTasks);
			_diagrammer.removeEventListener(VisualizerEvent.ELEMENTS_DRAG_FINISHED, checkUndoRedoTasks);
			_diagrammer.removeEventListener(VisualizerEvent.ELEMENTS_SELECTION_CHANGED, checkUndoRedoTasks);
			_diagrammer.removeEventListener(VisualizerEvent.ELEMENTS_PROPERTY_CHANGED, checkUndoRedoTasks);
			_diagrammer.removeEventListener(VisualizerEvent.ELEMENTS_EXPANDED_COLLAPSED, checkUndoRedoTasks);
			_diagrammer.removeEventListener(VisualizerEvent.ELEMENT_CLICKED, checkUndoRedoTasks);
			_diagrammer.removeEventListener(VisualizerEvent.ELEMENT_ROLL_OVER, checkUndoRedoTasks);
			_diagrammer.removeEventListener(VisualizerEvent.ELEMENT_ROLL_OUT, checkUndoRedoTasks);
		}
		
		/**
		 * Check if there is tasks undo-ables and/or redo-ables 
		 */	
		public function checkUndoRedoTasks(event:VisualizerEvent):void
		{
			var undoTasks:Array = UndoAction(_diagrammer.getActionInstance(UndoAction.ID)).tasksList;
			var redoTasks:Array = RedoAction(_diagrammer.getActionInstance(RedoAction.ID)).tasksList; 
			_canUndo = undoTasks ? undoTasks.length > 0 : false;
			_canRedo = redoTasks ? redoTasks.length > 0 : false;
			
			dispatchEvent(new Event("UndoRedoTasksChanged"));
		}
	}
}