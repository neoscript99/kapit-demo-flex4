package fr.kapit.lab.demo.util
{
	import fr.kapit.actionscript.system.IDisposable;
	import fr.kapit.visualizer.base.sprite.GenericLink;
	
	public class GenericLinkNormalizer implements IDisposable
	{
		protected var _arrowSourceTypeNormalizer:ValuesNormalizer = new ValuesNormalizer();
		protected var _arrowTargetTypeNormalizer:ValuesNormalizer = new ValuesNormalizer();
		
		protected var _lineColorNormalizer:ValuesNormalizer = new ValuesNormalizer();
		protected var _thicknessNormalizer:ValuesNormalizer = new ValuesNormalizer();
		protected var _renderingPolicyNormalizer:ValuesNormalizer = new ValuesNormalizer();
		
		
		public function GenericLinkNormalizer()
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
			_arrowSourceTypeNormalizer = null;
			_arrowTargetTypeNormalizer = null;
			
			_lineColorNormalizer = null;
			_thicknessNormalizer = null;
			_renderingPolicyNormalizer = null;
		}
		
		
		public function clear():void
		{
			_arrowSourceTypeNormalizer.clear();
			_arrowTargetTypeNormalizer.clear();
			
			_lineColorNormalizer.clear();
			_thicknessNormalizer.clear();
			_renderingPolicyNormalizer.clear();
		}
		
		public function push(link:GenericLink):void
		{
			_arrowSourceTypeNormalizer.push(link.arrowSourceType);
			_arrowTargetTypeNormalizer.push(link.arrowTargetType);
			
			_lineColorNormalizer.push(link.linkStyle.lineColor);
			_thicknessNormalizer.push(link.linkStyle.thickness);
			_renderingPolicyNormalizer.push(link.linkStyle.renderingPolicy);
		}
		
		
		public function get normalizedArrowSourceType():NormalizedValue
		{
			return _arrowSourceTypeNormalizer.getNormalizedValue();
		}
		
		public function get normalizedArrowTargetType():NormalizedValue
		{
			return _arrowTargetTypeNormalizer.getNormalizedValue();
		}
		
		public function get normalizedLineColor():NormalizedValue
		{
			return _lineColorNormalizer.getNormalizedValue();
		}
		public function get normalizedThickness():NormalizedValue
		{
			return _thicknessNormalizer.getNormalizedValue();
		}
		public function get normalizedRenderingPolicy():NormalizedValue
		{
			return _renderingPolicyNormalizer.getNormalizedValue();
		}
		
	}
}