package fr.kapit.lab.demo.ui.components.map
{
	import flash.geom.Point;
	
	import fr.kapit.lab.demo.data.config.MapParams;
	import fr.kapit.visualizer.layers.ICustomLayer;

	public interface IMapLayer extends ICustomLayer
	{
		function get level():Number;
		function get mapParams():MapParams;
		function set mapParams(value:MapParams):void;
		function set mapVisualizer(value:MapVisualizer):void;
		function set forceUpdate(value:Boolean):void;
		function getPositionFromLatLong(latitude:Number, longitude:Number):Point;
		function centerByLatLong(latitude:Number, longitude:Number):void;
		function zoomAt(level:uint):void;
			
	}
}