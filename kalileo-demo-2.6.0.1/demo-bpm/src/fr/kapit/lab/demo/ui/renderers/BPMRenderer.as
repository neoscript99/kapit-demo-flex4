package fr.kapit.lab.demo.ui.renderers
{
	import spark.components.SkinnableContainer;
	
	public class BPMRenderer extends SkinnableContainer
	{
		
		[Bindable] public var type:String;
		[Bindable] public var icon:Object;
		
		public function BPMRenderer()
		{
			super();
			this.buttonMode = true;
			this.tabEnabled = false;
		}
	}
}