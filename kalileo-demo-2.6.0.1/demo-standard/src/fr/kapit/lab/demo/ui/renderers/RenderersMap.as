package fr.kapit.lab.demo.ui.renderers
{
	import fr.kapit.datavisualization.assets.EmbeddedAssets;

	public class RenderersMap
	{
		public static function getImageFromID(id:String):Object
		{
			switch(id)
			{
				case "losange_1" : return new EmbeddedAssets.RENDERER_LOSANGE_1(); break;
				case "losange_2" : return new EmbeddedAssets.RENDERER_LOSANGE_2(); break;
				case "losange_3" : return new EmbeddedAssets.RENDERER_LOSANGE_3(); break;
				case "losange_4" : return new EmbeddedAssets.RENDERER_LOSANGE_4(); break;

				case "circle_1" : return new EmbeddedAssets.RENDERER_CIRCLE_1(); break;
				case "circle_2" : return new EmbeddedAssets.RENDERER_CIRCLE_2(); break;
				case "circle_3" : return new EmbeddedAssets.RENDERER_CIRCLE_3(); break;
				case "circle_4" : return new EmbeddedAssets.RENDERER_CIRCLE_4(); break;
				
				default :
					return null;
			}
		}
	}
}