package fr.kapit.lab.demo.util
{
	import flash.text.TextFormat;
	
	import fr.kapit.actionscript.system.IDisposable;
	import fr.kapit.lab.demo.models.constants.TextStyleFlags;
	import fr.kapit.visualizer.renderers.DefaultItemRenderer;
	
	public class DefaultItemRendererNormalizer implements IDisposable
	{
		protected var _dataLabelNormalizer:ValuesNormalizer = new ValuesNormalizer();
		
		protected var _backgroundAlphaNormalizer:ValuesNormalizer = new ValuesNormalizer();
		protected var _backgroundColorsNormalizer:ValuesNormalizer = new ValuesNormalizer();
		
		protected var _borderAlphaNormalizer:ValuesNormalizer = new ValuesNormalizer();
		protected var _borderColorNormalizer:ValuesNormalizer = new ValuesNormalizer();
		protected var _borderThicknessNormalizer:ValuesNormalizer = new ValuesNormalizer();
		
		protected var _fieldsTextSizeNormalizer:ValuesNormalizer = new ValuesNormalizer();
		protected var _fieldsTextColorNormalizer:ValuesNormalizer = new ValuesNormalizer();
		
		protected var _fieldsTextFormatNormalizer:ValuesNormalizer = new ValuesNormalizer();
		
		/**
		 * Property to check on the data to get the label.
		 * If not set, then labels are not considered at all.
		 */
		public var nodeLabelFields:String = null;
		
		
		/**
		 * Constructeur.
		 */
		public function DefaultItemRendererNormalizer()
		{
		}
		
		
		/**
		 * @private
		 * Converts the given text format to a string, for comparison purpose.
		 *
		 * @param objTextFormat
		 * 		textformat
		 * @return
		 * 		String
		 */
		private function fieldsTextFormatToString(value:TextFormat):String
		{
			if (null == value)
				return null;
			
			return TextStyleFlags.textFormatToFlags(value).toString();
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
			
			_backgroundAlphaNormalizer = null;
			_backgroundColorsNormalizer = null;
			
			_borderAlphaNormalizer = null;
			_borderColorNormalizer = null;
			_borderThicknessNormalizer = null;
			
			_fieldsTextColorNormalizer = null;
			_fieldsTextSizeNormalizer = null;
			
			_fieldsTextFormatNormalizer = null;
		}
		
		
		public function clear():void
		{
			_dataLabelNormalizer.clear();
			
			_backgroundAlphaNormalizer.clear();
			_backgroundColorsNormalizer.clear();
			
			_borderAlphaNormalizer.clear();
			_borderColorNormalizer.clear();
			_borderThicknessNormalizer.clear();
			
			_fieldsTextColorNormalizer.clear();
			_fieldsTextSizeNormalizer.clear();
			
			_fieldsTextFormatNormalizer.clear();
		}
		
		public function push(renderer:DefaultItemRenderer):void
		{
			try
			{
				_dataLabelNormalizer.push(renderer.data[nodeLabelFields]);
			}
			catch (e:Error)
			{
				_dataLabelNormalizer.push(null, "");
			}
			
			_backgroundAlphaNormalizer.push(renderer.backgroundAlphas);
			_backgroundColorsNormalizer.push(renderer.backgroundColors);
			
			_borderAlphaNormalizer.push(renderer.borderAlpha);
			_borderColorNormalizer.push(renderer.borderColor);
			_borderThicknessNormalizer.push(renderer.borderThickness);
			
			_fieldsTextColorNormalizer.push(renderer.fieldsTextColor);
			_fieldsTextSizeNormalizer.push(renderer.fieldsTextSize);
			
			_fieldsTextFormatNormalizer.push(
				renderer.fieldsTextFormat, fieldsTextFormatToString(renderer.fieldsTextFormat)
			);
		}
		
		public function get normalizedDataLabel():NormalizedValue
		{
			return _dataLabelNormalizer.getNormalizedValue();
		}
		
		/*
		public function get normalizedBackgroundAlphas():NormalizedValue
		{
		return _objBackgroundAlphaNormalizer.getNormalizedValue();
		}
		*/
		public function get normalizedBackgroundColors():NormalizedValue
		{
			return _backgroundColorsNormalizer.getNormalizedValue();
		}
		
		/*
		public function get normalizedBorderAlpha():NormalizedValue
		{
		return _objBorderAlphaNormalizer.getNormalizedValue();
		}
		*/
		public function get normalizedBorderColor():NormalizedValue
		{
			return _borderColorNormalizer.getNormalizedValue();
		}
		public function get normalizedBorderThickness():NormalizedValue
		{
			return _borderThicknessNormalizer.getNormalizedValue();
		}
		
		public function get normalizedFieldsTextSize():NormalizedValue
		{
			return _fieldsTextSizeNormalizer.getNormalizedValue();
		}
		public function get normalizedFieldsTextColor():NormalizedValue
		{
			return _fieldsTextColorNormalizer.getNormalizedValue();
		}
		
		public function get normalizedFieldsTextFormat():NormalizedValue
		{
			return _fieldsTextFormatNormalizer.getNormalizedValue();
		}
	}
}