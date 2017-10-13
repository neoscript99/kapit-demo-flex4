package fr.kapit.lab.demo.util
{
	import fr.kapit.actionscript.system.IDisposable;
	import fr.kapit.visualizer.renderers.DefaultGroupRenderer;
	import fr.kapit.visualizer.renderers.DefaultItemRenderer;
	
	public class DefaultGroupRendererNormalizer implements IDisposable
	{
		protected var _dataLabelNormalizer:ValuesNormalizer = new ValuesNormalizer();
		
		protected var _backgroundColorsNormalizer:ValuesNormalizer = new ValuesNormalizer();
		
		protected var _borderColorNormalizer:ValuesNormalizer = new ValuesNormalizer();
		
		/**
		 * Property to check on the data to get the label.
		 * If not set, then labels are not considered at all.
		 */
		public var groupLabelField:String = null;
		
		
		public function DefaultGroupRendererNormalizer()
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
			_dataLabelNormalizer = null;
			_backgroundColorsNormalizer = null;
			_borderColorNormalizer = null;
		}
		
		
		public function clear():void
		{
			_dataLabelNormalizer.clear();
			_backgroundColorsNormalizer.clear();
			_borderColorNormalizer.clear();
		}
		
		public function push(renderer:DefaultGroupRenderer):void
		{
			try
			{
				_dataLabelNormalizer.push(renderer.data[groupLabelField]);
			}
			catch (e:Error)
			{
				_dataLabelNormalizer.push(null, "");
			}
			
			_backgroundColorsNormalizer.push( renderer.backgroundColors );
			_borderColorNormalizer.push( renderer.borderColor );
		}
		
		public function get normalizedDataLabel():NormalizedValue
		{
			return _dataLabelNormalizer.getNormalizedValue();
		}
		
		public function get normalizedBackgroundColors():NormalizedValue
		{
			return _backgroundColorsNormalizer.getNormalizedValue();
		}
		
		public function get normalizedBorderColor():NormalizedValue
		{
			return _borderColorNormalizer.getNormalizedValue();
		}
		
	}
}