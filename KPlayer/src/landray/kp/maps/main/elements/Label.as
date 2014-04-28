package landray.kp.maps.main.elements
{
	import com.kvs.ui.label.TextDrawer;
	
	import flash.display.Sprite;
	import flash.text.engine.BreakOpportunity;
	import flash.text.engine.CFFHinting;
	
	import flashx.textLayout.container.TextContainerManager;
	import flashx.textLayout.edit.EditingMode;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import model.vo.ElementVO;
	import model.vo.TextVO;
	
	import util.textFlow.FlowTextManager;
	import util.textFlow.ITextFlowLabel;
	
	/**
	 * 
	 */	
	public final class Label extends Element implements ITextFlowLabel
	{
		public function Label($vo:ElementVO)
		{
			super($vo);
			init();
		}
		
		private function init():void
		{
			textDrawer = new TextDrawer(this);
			addChild(textCanvas = new Sprite);
			
			textManager = new TextContainerManager(textCanvas);
			textManager.editingMode = EditingMode.READ_ONLY;
			
			textLayoutFormat = new TextLayoutFormat;
			textLayoutFormat.cffHinting = CFFHinting.NONE;
			textLayoutFormat.textAlign = TextAlign.LEFT;
			textLayoutFormat.breakOpportunity = BreakOpportunity.AUTO;
			
			textManager.hostFormat = textLayoutFormat;
		}
		
		public function check():void
		{
			if (visible)
			{
				textDrawer.checkTextBm(graphics, textCanvas, textVO.scale * ((parent) ? parent.scaleX : 1));
			}
		}
		
		/**
		 */		
		override public function render():void
		{
			if(!rendered)
			{
				FlowTextManager.renderTextVOLabel(this, textVO);
				renderAfterLabelRender();
				super.render();
			}
			check();
		}
		
		public function afterReRender():void
		{
			textVO.width  = textManager.compositionWidth;
			textVO.height = textManager.compositionHeight;
			
			renderAfterLabelRender();
			check();
		}
		
		private function renderAfterLabelRender():void
		{
			textCanvas.x = - textVO.width  * .5;
			textCanvas.y = - textVO.height * .5;
		}
		
		public function get ifMutiLine():Boolean
		{
			return textVO.ifMutiLine;
		}
		public function set ifMutiLine(value:Boolean):void
		{
			textVO.ifMutiLine = value;
		}
		
		public function get fixWidth():Number
		{
			return vo.width;
		}
		public function set fixWidth(value:Number):void
		{
			vo.width = value;
		}
		
		/**
		 */		
		public function get text():String
		{
			return textVO.text;
		}
		public function set text(value:String):void
		{
			textVO.text = value;
		}
		
		public function get textManager():TextContainerManager
		{
			return __textManager;
		}
		public function set textManager(value:TextContainerManager):void
		{
			__textManager = value;
		}
		private var __textManager:TextContainerManager;
		
		public function get textLayoutFormat():TextLayoutFormat
		{
			return __textLyoutFormat;
		}
		
		/**
		 * @private
		 */
		public function set textLayoutFormat(value:TextLayoutFormat):void
		{
			__textLyoutFormat = value;
		}
		
		private var __textLyoutFormat:TextLayoutFormat;
		
		public function get smooth():Boolean
		{
			return __smooth;
		}
		
		public function set smooth(value:Boolean):void
		{
			if (__smooth!= value)
			{
				__smooth = value;
				textCanvas.visible = smooth;
				shape.visible = !smooth;
			}
		}
		
		private var __smooth:Boolean = true;
		
		private function get textVO():TextVO
		{
			return vo as TextVO;
		}
		
		private var textDrawer:TextDrawer;
		
		private var textCanvas:Sprite;
	}
}