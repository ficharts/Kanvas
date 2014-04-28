package com.kvs.ui.label
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.engine.BreakOpportunity;
	import flash.text.engine.CFFHinting;
	import flash.text.engine.FontLookup;
	
	import flashx.textLayout.container.TextContainerManager;
	import flashx.textLayout.edit.EditingMode;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import util.textFlow.FlowTextManager;
	import util.textFlow.ITextFlowLabel;
	
	/**
	 * 采用文本引擎的最小label单元
	 */	
	public class TextFlowLabel extends Sprite implements ITextFlowLabel
	{
		public function TextFlowLabel()
		{
			super();
			
			addChild(shape = new Shape).visible = false;
			addChild(textCanvas);
			textDrawer = new TextDrawer(this);
			
			_textManager = new TextContainerManager(textCanvas);
			_textManager.editingMode = EditingMode.READ_ONLY;
			
			_textLayoutFormat = new TextLayoutFormat;
			_textLayoutFormat.cffHinting = CFFHinting.NONE;
			_textLayoutFormat.textAlign = TextAlign.LEFT;
			_textLayoutFormat.fontLookup = FontLookup.EMBEDDED_CFF;
			_textLayoutFormat.breakOpportunity = BreakOpportunity.AUTO;
			
			_textManager.hostFormat = _textLayoutFormat;
		}
		
		/**
		 */		
		public var ifTextBitmap:Boolean = false;
		
		/**
		 */		
		private var textDrawer:TextDrawer;
		
		/**
		 */		
		private var textCanvas:Sprite = new Sprite;
		
		/**
		 * 默认文本采用设备字体模式渲染, 如果需要放大文本，则可以考虑嵌入字体方式渲染
		 */		
		public function renderLabel(textformat:TextFormat, ifUseEmbedFont:Boolean = true):void
		{
			this.textformat = textformat;
			this.ifUseEmbedFont = ifUseEmbedFont;
			FlowTextManager.render(this, textformat, ifUseEmbedFont);
			
			/*textCanvas.x = - textCanvas.width  * .5;
			textCanvas.y = - textCanvas.height * .5;*/
			
			if (ifTextBitmap)
				textDrawer.checkTextBm(shape.graphics, textCanvas, globleScale);
		}
		
		/**
		 */		
		public function checkTextBm(scale:Number):void
		{
			globleScale = scale;
			
			if (ifTextBitmap)
				textDrawer.checkTextBm(shape.graphics, textCanvas, globleScale);
		}
		
		/**
		 * 记录全局比例
		 */		
		private var globleScale:Number = 1;
		
		/**
		 */
		public function get text():String
		{
			return _text;
		}
		
		/**
		 */		
		private var ifChanged:Boolean = false;
		
		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			if (_text != value)
			{
				_text = value;
				ifChanged = true;
			}
		}
		
		/**
		 */		
		private var _text:String = '';
		
		/**
		 */		
		public function get textLayoutFormat():TextLayoutFormat
		{
			return _textLayoutFormat; 
		}
		
		/**
		 */		
		private var _textLayoutFormat:TextLayoutFormat;
		
		/**
		 */		
		public function get textManager():TextContainerManager
		{
			return _textManager;
		}
		
		/**
		 */		
		private var _textManager:TextContainerManager;
		
		/**
		 */
		public function get ifMutiLine():Boolean
		{
			return _ifMutiLine;
		}
		
		/**
		 */
		public function set ifMutiLine(value:Boolean):void
		{
			_ifMutiLine = value;
		}
		
		/**
		 */		
		private var _ifMutiLine:Boolean = false;
		
		/**
		 */		
		public function get fixWidth():Number
		{
			return _fixWidth;
		}
		
		/**
		 */
		public function set fixWidth(value:Number):void
		{
			_fixWidth = value;
		}
		
		/**
		 */		
		private var _fixWidth:Number = 0;
		
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
				shape.visible =!smooth;
			}
		}
		private var __smooth:Boolean = true;
		
		private var textformat:TextFormat;
		
		private var ifUseEmbedFont:Boolean;
		
		private var shape:Shape;
		
		/**
		 */		
		public function afterReRender():void
		{
			FlowTextManager.render(this, textformat, ifUseEmbedFont);
			
			if (ifTextBitmap)
				textDrawer.checkTextBm(shape.graphics, textCanvas, globleScale);
				
		}
	}
}