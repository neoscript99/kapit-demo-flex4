package fr.kapit.lab.demo.data
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class MindMapNodeData
	{
		public var label:String = "Topic";
		public var isRoot:Boolean
		public var decorators:ArrayCollection;
		public var comments:String;
		public var uid:String;
		public var metaData:Object;
	}
}