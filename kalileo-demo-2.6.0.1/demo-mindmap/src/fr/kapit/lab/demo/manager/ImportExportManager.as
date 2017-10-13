package fr.kapit.lab.demo.manager
{
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import fr.kapit.data.converter.DataConverter;
	import fr.kapit.diagrammer.Diagrammer;
	import fr.kapit.lab.demo.data.MindMapNodeData;
	import fr.kapit.lab.demo.popup.ErrorPopup;
	import fr.kapit.visualizer.VisualizerError;
	import fr.kapit.visualizer.constants.PrintPolicyConstants;
	
	import mx.core.IFlexDisplayObject;
	import mx.graphics.codec.PNGEncoder;
	import mx.managers.PopUpManager;

	public class ImportExportManager
	{
		protected var _diagrammer:Diagrammer;
		protected var _exportedXml:XML
		protected var _importedFile:FileReference;
		protected var _errorPopup:IFlexDisplayObject;
		
		public function ImportExportManager(value:Diagrammer)
		{
			super();
			_diagrammer = value
		}

		public function get diagrammer():Diagrammer
		{
			return _diagrammer;
		}

		public function set diagrammer(value:Diagrammer):void
		{
			_diagrammer = value;
		}

		public function saveAsXML():void
		{
			exportXML();
		}
		public function saveAsPNG():void
		{
			exportPNG();
			
		}
		public function importXML():void
		{
			importAsXML();
		}
		
		/* ********************
		* IMPORT Handlers 
		*********************** */
		protected function importedFile_errorHandler(event:ErrorEvent):void
		{
			if (!_diagrammer)
				return;
			throw new VisualizerError("There was an error while importing the XML file. Please try again, unless choose another file");
		}
		
		protected function importedFile_selectHandler(event:Event):void
		{
			_importedFile.addEventListener(Event.COMPLETE, importedFile_completeHandler);
			_importedFile.addEventListener(IOErrorEvent.IO_ERROR, importedFile_errorHandler);
			_importedFile.addEventListener(SecurityErrorEvent.SECURITY_ERROR, importedFile_errorHandler);
			_importedFile.load();
		}
		protected function importedFile_completeHandler(event:Event):void
		{
			_diagrammer.nodeImportDataFunction = importNodeFunction;

			const type:String = ".xml";
			if (_importedFile.name.toLowerCase().indexOf(type) != (_importedFile.name.length - type.length))
			{
				return importedFile_errorHandler(null);
			}
			
			try
			{
				var xml:XML = new XML(_importedFile.data.readUTFBytes(_importedFile.data.bytesAvailable));
				if (xml.name() == "diagram")
				{
					_diagrammer.fromXML(xml);
				}
				else
				{
					importedFile_errorHandler(null);
				}
			}
			catch (e:*)
			{
				importedFile_errorHandler(null);
			}
			
		}
		/* *************************
		* XML EXPORT HELPERS 
		****************************/
		
		protected function exportXML():void
		{
			createXML();
			var bytes:ByteArray = new ByteArray;
			bytes.writeUTFBytes(_exportedXml);
			var file:FileReference = new FileReference;
			file.save(bytes, "diagrammer_graph.xml");
		}
		
		private function createXML():void
		{
			_diagrammer.nodeExportDataFunction = exportNodeFunction;
			
			_exportedXml = new XML;
			if ((_diagrammer.toXML()).children().length() !=0)
				_exportedXml =_diagrammer.toXML();
		}
		private function exportNodeFunction(data:MindMapNodeData):XML
		{
			var xml:XML;
			xml = new XML(<data/>);
			if (data.hasOwnProperty("label"))
				xml.@label = data.label
			if (data.hasOwnProperty("isRoot"))
				xml.@isRoot = data.isRoot;
			
			return (xml);
		}
		/* *************************
		* XML IMPORT HELPERS 
		****************************/
		
		protected function importAsXML():void
		{
			_importedFile = new FileReference;
			_importedFile.addEventListener(Event.SELECT, importedFile_selectHandler);
			_importedFile.browse([new FileFilter("XML File", "*.xml")]);
		}
		
		private function importNodeFunction(xml:XML):MindMapNodeData
		{
			var data:MindMapNodeData=new MindMapNodeData;
			data.label= xml.@label.toString();
			data.isRoot = xml.@isRoot.toString() == "true" ? true : false;
			return data;
		}
		/* *************************
		* PNG EXPORT HELPERS 
		****************************/
		
		protected function exportPNG():void
		{
			var bitmapData:BitmapData = _diagrammer.getBitmapData(-1,-1,true,true,3,3,PrintPolicyConstants.printAllLayers);
			var ba:ByteArray = new PNGEncoder().encode(bitmapData);
			new FileReference().save(ba, "mindMap_snapshot.png");
		}
		
	
	
	
	}
}