package aerys.minko.render.effect.picking
{
	import aerys.minko.render.effect.IEffect;
	import aerys.minko.render.effect.IEffectPass;
	import aerys.minko.render.effect.SinglePassEffect;
	import aerys.minko.render.renderer.RendererState;
	import aerys.minko.render.target.AbstractRenderTarget;
	import aerys.minko.render.target.BackBufferRenderTarget;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.scene.data.ViewportData;
	import aerys.minko.type.enum.Blending;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class PickingEffect extends SinglePassEffect implements IEffect, IEffectPass
	{
		protected static const TARGET		: BackBufferRenderTarget	= new BackBufferRenderTarget(0, 0, 0);
		protected static const SHADER 		: PickingShader = new PickingShader();
		protected static const RECTANGLE 	: Rectangle 	= new Rectangle(0, 0, 10, 10);
		
		private var _renderTarget	: AbstractRenderTarget	= null;
		
		public function PickingEffect(priority		: Number		= 0,
									  renderTarget	: AbstractRenderTarget	= null)
		{
			super(SHADER, priority, renderTarget);
		}
		override public function fillRenderState(state			: RendererState,
												 styleData		: StyleData, 
												 transformData	: TransformData, 
												 worldData		: Dictionary) : Boolean
		{
			super.fillRenderState(state, styleData, transformData, worldData);
			
			var currentColor		: uint		= styleData.get(PickingStyle.CURRENT_COLOR, 0) as uint;
			var isOcludingObject	: Boolean	= styleData.get(PickingStyle.OCLUDER, true);
			var scissorRectangle	: Rectangle	= styleData.get(PickingStyle.RECTANGLE, 0) as Rectangle;
			
			if (!isOcludingObject && currentColor == 0)
				return false;
			
			var width	: uint = ViewportData(worldData[ViewportData]).width;
			var height	: uint = ViewportData(worldData[ViewportData]).height;
			
			if (!_renderTarget || _renderTarget.width != width || _renderTarget.height != height)
				_renderTarget = new BackBufferRenderTarget(width, height);
			
			state.blending			= Blending.NORMAL;
//			state.rectangle			= scissorRectangle;
			state.renderTarget		= _renderTarget;
			
			return true;
		}
	}
}