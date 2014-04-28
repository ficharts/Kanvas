package landray.kp.maps.mind.model
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	
	import model.vo.TextVO;

	public class RichTextVO extends TextVO
	{
		public function RichTextVO()
		{
			super();
			style = new LabelStyle;
			width = 10;
			height = 10;
		}
		
		private var _label:LabelStyle = new LabelStyle;
		/**
		 */		
		override public function set label(value:LabelStyle):void 
		{
			_label = value;
		}
		
		/**
		 */		
		override public function get label():LabelStyle 
		{
			return _label;
		}
		
		/**
		 * 设置文本颜色值
		 * @param value
		 * 
		 */
		public function set textColor(value:Object):void
		{			
			_textColor = StyleManager.setColor(value);
			
		}
		/**
		 * @private
		 */
		public function get textColor():Object
		{
			return _textColor;
		}
		private var _textColor:Object = 0x000000;
		
		/**
		 * 边框颜色
		 */
		public var frameColor:uint = 0x99cbff;
		
		/**
		 * 自动换行
		 */		
		public var wordWrap:Boolean = false;
		
		/**
		 * 字体样式
		 */
		public var font:String = "宋体";
		
		/**
		 * 矩形圆角宽度
		 */
		public var radius:Number = 10;
		
		/**
		 * 文字对齐
		 */		
		public var align:String = "left";
		
		/**
		 * 字体加粗
		 */
		public var bold:Boolean = false;
		
		/**
		 * 文字倾斜
		 */
		public var italic:Boolean = false;
		
		/**
		 * 下划线
		 */
		public var underline:Boolean = false;
		
		public var paddingLeft:Number = 5;
		
		public var paddingRight:Number = 5;
		
		public var paddingTop:Number = 5;
		
		public var paddingBottom:Number = 4;
	}
}