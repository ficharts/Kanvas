package com.kvs.ui.label
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.engine.CFFHinting;
	import flash.text.engine.FontLookup;
	
	import flashx.textLayout.container.ScrollPolicy;
	import flashx.textLayout.container.TextContainerManager;
	import flashx.textLayout.edit.EditingMode;
	import flashx.textLayout.edit.ISelectionManager;
	import flashx.textLayout.events.UpdateCompleteEvent;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import util.textFlow.FlowTextManager;
	
	/**
	 *
	 * 文本输入框
	 *  
	 * @author wanglei
	 * 
	 */	
	public class TextInputField extends Sprite 
	{
		public function TextInputField()
		{
			super();
			
			textLayoutFormat.fontLookup = FontLookup.DEVICE;
			textLayoutFormat.cffHinting = CFFHinting.NONE;
			textLayoutFormat.textAlign = TextAlign.LEFT;
				
			
			_textManager = new TextContainerManager(this);
			textManager.editingMode = EditingMode.READ_WRITE;
			textManager.hostFormat = textLayoutFormat;
			
			textManager.horizontalScrollPolicy = ScrollPolicy.OFF;
			textManager.verticalScrollPolicy = ScrollPolicy.OFF;
			textManager.addEventListener(UpdateCompleteEvent.UPDATE_COMPLETE, inputUpdateHandler);
			
			FlowTextManager.initTextSize(textManager);
			
			this.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		/**
		 */		
		private function clickHandler(evt:MouseEvent):void
		{
			var editM:ISelectionManager = textManager.beginInteraction();
			//editM.selectRange(startPos, startPos);
			editM.setFocus();
		}
		
		/**
		 */		
		public function get textWidth():Number
		{
			return textManager.compositionWidth;
		}
		
		/**
		 */		
		public function get textHeight():Number
		{
			return textManager.compositionHeight;
		}
		
		/**
		 */		
		public function set textWidth(value:Number):void
		{
			textManager.compositionWidth = value;
		}
		
		/**
		 */		
		public function set textHeight(value:Number):void
		{
			textManager.compositionHeight = value;
		}
		
		/**
		 */		
		public function updateLayout():void
		{
			textManager.updateContainer();
		}
		
		/**
		 */		
		public function get text():String
		{
			return textManager.getText();
		}
		
		/**
		 */		
		public function set text(value:String):void
		{
			textManager.setText(value);
			//textManager.updateContainer();new 
			
		}
		
		/**
		 */		
		public function get textLayoutFormat():TextLayoutFormat
		{
			return _textLayoutFormat;
		}
		
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
		private var _textLayoutFormat:TextLayoutFormat = new TextLayoutFormat;
		
		/**
		 * 文本输入过程中动态更新文本框尺寸
		 */		
		private function inputUpdateHandler(evt:UpdateCompleteEvent):void
		{
			var text:String = textManager.getText();
			
			this.graphics.clear();
			this.graphics.lineStyle(1, 0xeeeeee);
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, 0, textWidth, textHeight);
			this.graphics.endFill();
		}
	}
}