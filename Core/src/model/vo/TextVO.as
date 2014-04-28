package model.vo
{
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	
	import flash.text.TextFormat;
	
	/**
	 * 文字数据
	 */
	public class TextVO extends ElementVO
	{
		/**
		 */		
		public function TextVO()
		{
			super();
			
			this.styleType = 'text';
			this.type = 'text';
		}
		
		/**
		 */		
		public function textFormat():TextFormat
		{
			return this.label.getTextFormat(this);
		}
		
		/**
		 */		
		override public function set color(value:Object):void
		{
			super.color = value;
		}
		
		/**
		 */		
		private var _size:uint = 10;

		public function get size():uint
		{
			return _size;
		}

		public function set size(value:uint):void
		{
			_size = value;
		}

		/**
		 * 文字
		 */
		private var _text:String = "";
		
		/**
		 */		
		public function set text(value:String):void
		{
			/*
			//防止此字符导致的崩溃
			if (value.indexOf('\r') != -1)
				value = value.split('\r').join('');
			
			//防止此字符导致的崩溃
			if (value.indexOf('\n') != -1)
				value = value.split('\n').join('');
			*/
			_text = value;
		}
		
		/**
		 */		
		public function get text():String
		{
			return _text;
		}
		
		/**
		 */		
		public function set label(value:LabelStyle):void 
		{
			this.style = value;
		}
		
		/**
		 */		
		public function get label():LabelStyle 
		{
			return this.style as LabelStyle;
		}
		
		/**
		 */		
		private var _ifMutiLine:Boolean = false;

		/**
		 */
		public function get ifMutiLine():Object
		{
			return _ifMutiLine;
		}

		/**
		 * @private
		 */
		public function set ifMutiLine(value:Object):void
		{
			_ifMutiLine = XMLVOMapper.boolean(value);
		}
		
		/**
		 * 默认文本采用样式模版的颜色序号，如果用户选择了其他颜色，
		 * 
		 * 则认为用户采用了自定义颜色，样式改变时，文本颜色不随样式走
		 */
		public function get isCustomColor():Object
		{
			return _isCustomColor;
		}
		
		/**
		 * @private
		 */
		public function set isCustomColor(value:Object):void
		{
			_isCustomColor = XMLVOMapper.boolean(value);;
		}
		
		/**
		 */		
		private var _isCustomColor:Object = false;
		
		
	}
}