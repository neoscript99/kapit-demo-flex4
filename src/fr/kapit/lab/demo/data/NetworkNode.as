package fr.kapit.lab.demo.data
{
	import mx.utils.UIDUtil;

	/**
	 * Basic Node data.
	 * @author Kap IT
	 * 
	 */	
	public class NetworkNode
	{
		/**
		 * Asset Unique ID.
		 */		
		public var uid:String = UIDUtil.createUID();
		/**
		 * Asset Icon ID.
		 */		
		public var iconID:String;
		/**
		 * Asset icon used in the lib selector to represent it. 
		 */		
		public var icon:Object;
		/**
		 * Asset description. This field can be used as a extra information. 
		 */		
		public var description:String;
	}
}