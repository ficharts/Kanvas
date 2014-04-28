package landray.kp.maps.mind.view
{
	import com.kvs.ui.label.TextFlowLabel;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	import landray.kp.maps.mind.model.RichTextVO;
	
	/**
	 * 
	 */
	public class RichText extends Sprite
	{
		public function RichText($vo:RichTextVO)
		{
			super();
			vo = $vo;
			addChild(textLabel = new TextFlowLabel);
			
			//textLabel.ifTextBitmap = true;
			//trace("color:"+vo.label.format.color)
		}
		
		/**
		 * 渲染
		 */
		public function render(scale:Number = 1):void
		{
			if (rendered)
			{
				textLabel.checkTextBm(scale);
			}
			else
			{
				rendered = true;
				textLabel.text = vo.text;
				var format:TextFormat = vo.label.format.getFormat(vo);
				textLabel.renderLabel(format);
				textLabel.checkTextBm(scale);
				removeChild(textLabel);
				addChild(textLabel);
				var w:Number = Math.max(textLabel.width + vo.paddingLeft + vo.paddingRight, vo.width);
				var h:Number = Math.max(textLabel.height + vo.paddingTop + vo.paddingBottom, vo.height);
				graphics.clear();
				graphics.beginFill(0, 0);
				graphics.drawRect(0, 0, w, h);
				graphics.endFill();
				
				if (vo.style)
				{
					vo.style.tx = 0;
					vo.style.ty = 0;
					vo.style.width = w;
					vo.style.height = h;
					vo.style.radius = vo.radius;
					StyleManager.setShapeStyle(vo.style, graphics, vo);
					StyleManager.drawRect(this, vo.style, vo);
				}
				
				updateLayout();
			}
		}
		/**
		 * 更新布局
		 */
		public function updateLayout():void
		{
			textLabel.x = vo.paddingLeft;
			textLabel.y = vo.paddingTop;
		}
		
		public function get labelHeight():Number
		{
			return textLabel.height;
		}
		
		private var rendered:Boolean = false;
		
		private var vo:RichTextVO;
		
		//private var labelBitmap:Bitmap;
		
		private var textLabel:TextFlowLabel;
	}
}