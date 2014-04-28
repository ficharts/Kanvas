package com.kvs.ui.label
{
	import com.kvs.utils.StageUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	import com.kvs.utils.XMLConfigKit.style.Text;
	
	import flash.display.Sprite;
	
	/**
	 */	
	public class LabelUI extends Sprite
	{
		public function LabelUI()
		{
			super();
			
			this.mouseChildren = this.mouseEnabled = false;
			StageUtil.initApplication(this, render);
			preRender();
		}
		
		/**
		 * 为渲染做好准备
		 */		
		private function preRender():void
		{
			if (ifReady == false)
			{
				if (ifStyleAppled == false)
					XMLVOMapper.fuck(_styleXML, this.labelStyle);
				
				addChild(textField);
				ifReady = true;
			}
		}
		
		/**
		 */		
		private var ifReady:Boolean = false;
		
		/**
		 */		
		private var _text:String = 'label';

		/**
		 */
		public function get text():String
		{
			return _text;
		}

		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			_text = value;
		}
		
		/**
		 */		
		public function render():void
		{
			preRender();
			
			this.visible = labelStyle.enable;
			StyleManager.setLabelUIText(this, this.mdata);
			
			if (labelStyle.layout == LabelStyle.WRAP)
			{
				textField.ifMutiLine = true;
				
				textField.fixWidth = Math.max(minLabelWidth, maxLabelWidth - labelStyle.paddingLeft - labelStyle.paddingRight);
				
				textField.text = text;
				textField.renderLabel(labelStyle.getTextFormat(mdata));
			}
			else
			{
				textField.ifMutiLine = false;
				textField.fixWidth = 0;
				
				textField.text = text;
				textField.renderLabel(labelStyle.getTextFormat(mdata));
			}
			
			StyleManager.setEffects(textField, labelStyle.text as Text, mdata);
			
			// 绘制背景
			this.graphics.clear();
			StyleManager.setShapeStyle(labelStyle, this.graphics, this.mdata);
			this.graphics.drawRoundRect(0, 0, this.width, this.height, labelStyle.radius, labelStyle.radius);
			this.graphics.endFill();
			
			textField.x = labelStyle.paddingLeft;
			textField.y = labelStyle.paddingTop;
		}
		
		/**
		 */		
		public var maxLabelWidth:Number = 100;
		
		/**
		 */		
		public var minLabelWidth:Number = 15;
		
		/**
		 * 相对于某点的布局, 默认居中
		 */		
		public function layout(x:Number, y:Number):void
		{
			if (labelStyle.hAlign == 'right')
			{
				this.x = x //+ labelStyle.hPadding;
			}
			else if (labelStyle.hAlign == 'left')
			{
				this.x = x - this.width //- labelStyle.hPadding;
			}
			else
			{
				this.x = x - this.width / 2;
			}
			
			// 垂直布局
			if (labelStyle.vAlign == 'bottom')
			{
				this.y = y //+ labelStyle.vPadding;
			}
			else if (labelStyle.vAlign == 'top')
			{
				this.y = y - this.height //- labelStyle.vPadding;	
			}
			else
			{
				this.y = y - this.width / 2;	
			}
		}
		
		/**
		 */		
		override public function get width():Number
		{
			return textField.width + labelStyle.paddingLeft + labelStyle.paddingRight;
		}
		
		/**
		 */		
		override public function get height():Number
		{
			return textField.height + labelStyle.paddingTop + labelStyle.paddingBottom;
		}
		
		/**
		 */		
		protected var textField:TextFlowLabel = new TextFlowLabel();
		
		/**
		 */		
		public function get style():LabelStyle
		{
			return labelStyle;
		}
		
		/**
		 */		
		public function set style(value:LabelStyle):void
		{
			labelStyle = value;
		}
		
		/**
		 */		
		public function set styleXML(value:XML):void
		{
			_styleXML = XMLVOMapper.extendFrom(_styleXML, value.copy());
			XMLVOMapper.fuck(_styleXML, this.labelStyle);
			
			ifStyleAppled = true;
		}
		
		/**
		 */		
		private var ifStyleAppled:Boolean = false;
		
		/**
		 */		
		private var _metaData:Object;

		public function get mdata():Object
		{
			return _metaData;
		}

		public function set mdata(value:Object):void
		{
			_metaData = value;
		}
		
		/**
		 */		
		private var labelStyle:LabelStyle = new LabelStyle;
		
		/**
		 */		
		private var _styleXML:XML = <label radius='0' vPadding='5' hPadding='5'>
									<format color='#555555' font='华文细黑' size='12'/>
								  </label>
		
		
	}
}