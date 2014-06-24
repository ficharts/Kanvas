package landray.kp.maps.main.elements
{
	import com.kvs.ui.label.TextDrawer;
	
	import flash.display.DisplayObject;
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
	
	import view.element.IText;
	
	/**
	 * 
	 */	
	public final class Label extends Element implements ITextFlowLabel, IText
	{
		public function Label($vo:ElementVO)
		{
			super($vo);
			init();
			
			useBitmap();
		}
		
		/**
		 */		
		public function useBitmap():void
		{
			textCanvas.visible = false;
			shape.visible = true;
		}
		
		/**
		 */		
		public function useText():void
		{
			textCanvas.visible = true;
			shape.visible = false;
		}
		
		/**
		 */		
		override public function get canvas():DisplayObject
		{
			return _canvas;
		}
		
		/**
		 */		
		private var _canvas:Sprite = new Sprite;
		
		/**
		 */		
		private function init():void
		{
			_canvas.addChild(shape);
			_canvas.addChild(textCanvas = new Sprite);
			addChild(_canvas);
			
			textDrawer = new TextDrawer(this);
			textManager = new TextContainerManager(textCanvas);
			textManager.editingMode = EditingMode.READ_ONLY;
			
			textLayoutFormat = new TextLayoutFormat;
			textLayoutFormat.cffHinting = CFFHinting.NONE;
			textLayoutFormat.textAlign = TextAlign.LEFT;
			textLayoutFormat.breakOpportunity = BreakOpportunity.AUTO;
			
			textManager.hostFormat = textLayoutFormat;
		}
		
		/**
		 */		
		public function check(force:Boolean = false):void
		{
			if (visible || force)
				textDrawer.checkTextBm(graphics, textCanvas, textVO.scale * ((parent) ? parent.scaleX : 1), true, force);
		}
		
		/**
		 */		
		override public function render():void
		{
			if(!rendered)
			{
				FlowTextManager.updateTexLayout(text, textManager, fixWidth);
				FlowTextManager.renderTextVOLabel(this, textVO);
				textVO.width  = textManager.compositionWidth;
				textVO.height = textManager.compositionHeight;
				FlowTextManager.updateTexLayout(text, textManager, fixWidth);
				textVO.width  = textManager.compositionWidth;
				textVO.height = textManager.compositionHeight;
				renderAfterLabelRender();
				super.render();
			}
			
			check(true);
		}
		
		/**
		 */		
		public function afterReRender():void
		{
			FlowTextManager.updateTexLayout(text, textManager, fixWidth);
			
			textVO.width  = textManager.compositionWidth;
			textVO.height = textManager.compositionHeight;
			
			renderAfterLabelRender();
			
			super.render();
			
			check(true);
		}
		
		private function renderAfterLabelRender():void
		{
			textCanvas.x = - textVO.width  * .5;
			textCanvas.y = - textVO.height * .5;
		}
		
		/**
		 */		
		public function get ifMutiLine():Boolean
		{
			return textVO.ifMutiLine;
		}
		public function set ifMutiLine(value:Boolean):void
		{
			textVO.ifMutiLine = value;
		}
		
		/**
		 */		
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
		
		/**
		 */		
		private function get textVO():TextVO
		{
			return vo as TextVO;
		}
		
		private var textDrawer:TextDrawer;
		
		private var textCanvas:Sprite;
	}
}