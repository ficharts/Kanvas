package landray.kp.maps.mind.view
{	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import landray.kp.controlIcons.icon_control_expand_btn;
	import landray.kp.controlIcons.icon_control_merger_btn;
	import landray.kp.maps.mind.core.mm_internal;
	import landray.kp.maps.mind.event.MindToolEvent;
	import landray.kp.maps.mind.model.TreeElementVO;
	
	use namespace mm_internal;
	
	public class TreeElement extends Sprite
	{
		public function TreeElement($vo:TreeElementVO)
		{
			this.vo = $vo;
			addChild(richText = new RichText(vo.richText));
			
			if (vo.children.length > 0)
			{
				expand_btn = new icon_control_expand_btn();
				merger_btn = new icon_control_merger_btn();
				expand_btn.buttonMode = merger_btn.buttonMode = true;
				addChild(expand_btn);
				addChild(merger_btn);
				expand_btn.addEventListener(MouseEvent.CLICK, expandHandler, false, 0,true);
				merger_btn.addEventListener(MouseEvent.CLICK, mergerHandler, false, 0,true);
				showBtn();
			}
			
			mouseEnabled = richText.mouseEnabled = richText.mouseChildren = richText.buttonMode = (vo.url != "");
			
			if (vo.docCount != "0" && vo.docCount != "")
			{
				addChild(hotSopt = new RichText(vo.hotSopt));
				hotSopt.mouseEnabled = hotSopt.mouseChildren = mouseEnabled;
			}
			
			if (mouseEnabled)
				richText.addEventListener(MouseEvent.CLICK, richChilckHandler, false, 0, true);
			else
				mouseChildren = (vo.children.length != 0);
		}
		
		private function richChilckHandler(event:MouseEvent):void
		{
			try
			{
				if(vo.url != "")
				{
					var _reURL:URLRequest=new URLRequest(vo.url);
					var _reType:String="_blank";
					navigateToURL(_reURL, _reType);
				}
			} 
			catch(error:Error) 
			{
				trace(error.message);
			}
		}
		
		private function expandHandler(e:MouseEvent):void
		{
			expanded = true;
			var evt:MindToolEvent = new MindToolEvent(MindToolEvent.EXPAND, true);
			evt.vo = vo;
			dispatchEvent(evt);
			showBtn();
		}
		
		private function mergerHandler(e:MouseEvent):void
		{
			expanded = false;
			var evt:MindToolEvent = new MindToolEvent(MindToolEvent.MERGER, true);
			evt.vo = vo;
			dispatchEvent(evt);
			showBtn();
		}
		
		/**
		 * 隐藏所有子项
		 */
		public function hideChild(child:Vector.<TreeElement>):void
		{
			for (var i:int = 0; i < child.length; i++) 
			{
				child[i].parent.removeChild(child[i]);
				hideChild(child[i].childs);
			}
		}
		
		/**
		 * 显示所有子项
		 */
		public function showChild(child:Vector.<TreeElement>):void
		{
			for (var i:int = 0; i < child.length; i++) 
			{
				child[i].parent.addChild(child[i]);
				if (child[i].expanded)
					showChild(child[i].childs);
			}
		}
		
		/**
		 * 渲染
		 */
		public function render(scale:Number = 1):void
		{
			richText.render(scale);
			if (hotSopt) 
				hotSopt.render(scale);
			if (expand_btn)
				expand_btn.scaleX = expand_btn.scaleY = merger_btn.scaleX = merger_btn.scaleY = (scale > 3) ? Math.max(0.2, 1.5 / scale) : .5;
			if (rendered == false)
			{
				rendered = true;
				//布局文本
				var halfW:Number = richText.width * .5;
				var halfH:Number = richText.height * .5;
				richText.x = - halfW;
				richText.y = - halfH;
				
				//布局红色提示
				if (hotSopt)
				{
					hotSopt.x = - .5 * hotSopt.width  + halfW * ((vo.hDirection == "right" || vo.level == 1) ? -1 : 1);
					hotSopt.y = - .5 * hotSopt.height - halfH;
				}
				
				//布局展开关闭按钮
				if (expand_btn)
				{
					merger_btn.x = expand_btn.x = (halfW + vo.btnGap) * ((vo.hDirection == "right" || vo.level == 1) ? 1: -1);
					showBtn();
				}
			}
		}
		
		/**
		 * 显示按钮
		 */
		private function showBtn():void
		{
			expand_btn.visible = ! expanded;
			merger_btn.visible =   expanded;
		}
		/**
		 * 隐藏按钮
		 */
		private function hideBtn():void
		{
			if (expanded)
			{
				expand_btn.visible = false;
				merger_btn.visible = false;
			}
		}
		
		public function set expanded(value:Boolean):void 
		{
			vo.expand = value;
		}
		
		public function get expanded():Boolean 
		{
			return vo.expand;
		}
		
		
		/**
		 * 底
		 **/
		mm_internal var richText:RichText;
		
		/**
		 * 红色点显示文档数目
		 */
		mm_internal var hotSopt:RichText;
		
		private var rendered:Boolean = false;
		
		/**
		 * 父元素
		 */
		mm_internal var father:TreeElement = null;
		
		/**
		 * 子集
		 */
		mm_internal var childs:Vector.<TreeElement> = new Vector.<TreeElement>();
		
		/**
		 * 展开按钮
		 */
		private var expand_btn:icon_control_expand_btn;
		
		/**
		 * 合并按钮
		 */
		private var merger_btn:icon_control_merger_btn;
		
		mm_internal var vo:TreeElementVO;
	}
}