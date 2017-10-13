package fr.kapit.lab.demo.data
{
	import flash.geom.Point;
	
	import fr.kapit.diagrammer.Diagrammer;
	import fr.kapit.diagrammer.base.uicomponent.container.DiagramTable;
	import fr.kapit.layouts.algorithms.orthogonal.OrthogonalLayout;
	import fr.kapit.visualizer.base.ITable;
	import fr.kapit.visualizer.events.VisualizerEvent;

	public class GrapheConstructor
	{		
		public static function construct(diagrammer:Diagrammer):void
		{
			diagrammer.removeAll();
			diagrammer.dispatchVisualizerEvent(VisualizerEvent.DATA_LOADED,[],new Object());
			var table:ITable = diagrammer.addTable({type:'a'},new Point(10,10),600,200,2,1,1,1,600,100);
			//table.isFixed = true;
			
		}
	}
}