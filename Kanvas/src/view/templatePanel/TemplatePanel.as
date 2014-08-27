package view.templatePanel
{
	import com.kvs.ui.Panel;
	import com.kvs.ui.button.LabelBtn;
	import com.kvs.utils.RexUtil;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.layout.BoxLayout;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	/**
	 * 
	 * @author wanglei
	 * 
	 */	
	public final class TemplatePanel extends Panel
	{
		public function TemplatePanel($core:Kanvas)
		{
			super();
			core = $core;
		}
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			
			title = "请选择模板";
			
			w = 880;
			h = 576;
			
			addChild(templatesContainer = new Sprite);
			
			scrollProxy = new TemplatesScrollProxy(this);
			
			boxLayout = new BoxLayout;
			boxLayout.setLoc(gap, barHeight);
			boxLayout.setItemSizeAndFullWidth(w, itemW, itemH, 10);
			boxLayout.vGap = 30;
			boxLayout.ready();
			
			cancel = new LabelBtn;
			cancel.w = 120;
			cancel.h = 30;
			cancel.x = w - cancel.w - gap;
			cancel.y = (h - barHeight) + (barHeight - cancel.h) / 2;
			cancel.text = "使用空白模板";
			cancel.bgStyleXML = submitBgStyle;
			cancel.labelStyleXML = submitStyle;
			cancel.addEventListener(MouseEvent.CLICK, cancelClickHandler);
			addChild(cancel);
			
			submit = new LabelBtn;
			submit.w = 120;
			submit.h = 30;
			submit.x = cancel.x - submit.w - 10;;
			submit.y = cancel.y;
			submit.text = "使用选定模板";
			submit.bgStyleXML = <states>
									<normal>
										<fill color='#539fd8' alpha='1'/>
									</normal>
									<hover>
										<fill color='#3c92e0' alpha='0.9' angle="90"/>
									</hover>
									<down>
										<fill color='#539fd8' alpha='0.3' angle="90"/>
									</down>
								</states>;
			
			submit.labelStyleXML = <label vAlign="center">
										<format color='FFFFFF' font='微软雅黑' size='12' letterSpacing="3"/>
									</label>;
			
			submit.addEventListener(MouseEvent.CLICK, submitClickHandler);
			submit.enable = false;
			addChild(submit);
			
			render();
		}
		
		/**
		 * 每个模版截图的宽高 
		 */		
		private var itemW:uint = 160;
		private var itemH:uint = 120;
		
		/**
		 */		
		override public function updateLayout():void
		{
			super.updateLayout();
			
			if (scrollProxy)
			{
				scrollProxy.updateMask();
				scrollProxy.update();
			}
			
			x = .5 * (stage.stageWidth - w);
			y = .5 * (stage.stageHeight - h);
			
			graphics.clear();
			graphics.beginFill(0xFFFFFF, 1);
			graphics.drawRect(- x, - y, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			bgShape.graphics.beginFill(0xFFFFFF);
			bgShape.graphics.drawRect(0, 0, w, h - barHeight);
			bgShape.graphics.endFill();
			
			//边框
			bgShape.filters = [new GlowFilter(0x000000, .2, 10, 10, 2, 3)];			
		}
		
		/**
		 */		
		private var gap:uint = 20;
		
		/**
		 */		
		public function get fullSize():Number
		{
			return (boxLayout) ? boxLayout.getRectHeight() : 0;
		}
		
		/**
		 */		
		public function initTemplate(templateData:XML):void
		{
			for each (var xml:XML in templateData.children())
			{
				var item:TemplateItem = new TemplateItem;
				XMLVOMapper.fuck(xml, item);
				
				item.w = itemW;
				item.h = itemH; 
					
				templatesContainer.addChild(item);
				boxLayout.layout(item);
				item.addEventListener(MouseEvent.DOUBLE_CLICK, templateDoubleClickHandler);
			}
			
			if (scrollProxy)
			{
				scrollProxy.updateMask();
				scrollProxy.update();
			}
			
			templatesContainer.addEventListener(MouseEvent.CLICK, templateClickedHandler);
		}
		
		/**
		 */		
		private function submitClickHandler(e:MouseEvent):void
		{
			if (curItem)
			{
				core.api.openTemplate(curItem.path);
				cancelClickHandler(null);
			}
		}
		
		/**
		 */		
		private function cancelClickHandler(e:MouseEvent):void
		{
			close(stage.stageWidth * .5, stage.stageHeight * .5 + 10);
		}
		
		/**
		 */		
		private function templateDoubleClickHandler(e:MouseEvent):void
		{
			if (curItem)
			{
				core.api.openTemplate(curItem.path);
				cancelClickHandler(null);
			}
		}
		
		/**
		 */		
		private function templateClickedHandler(e:MouseEvent):void
		{
			if (e.target is TemplateItem)
			{
				var item:TemplateItem = TemplateItem(e.target);
				if (curItem) 
				{
					if (item != curItem)
					{
						item.selected = true;
						curItem.selected = false;
						curItem = item;
					}
					else
					{
						curItem.selected = false;
						curItem = null;
						submit.enable = false;
					}
				}
				else
				{
					curItem = item;
					item.selected = true;
					submit.enable = true;
				}
				
				
			}
		}
		
		private var curItem:TemplateItem;
		
		private var core:Kanvas;
		
		private var submit:LabelBtn;
		
		private var cancel:LabelBtn;
		
		private var scrollProxy:TemplatesScrollProxy;
		
		private var boxLayout:BoxLayout;
		
		private var bitmap:Bitmap;
		
		internal var templatesContainer:Sprite;
		
		private static const submitBgStyle:XML = 
			<states>
				<normal>
					<fill color='#FFFFFF' alpha='1'/>
				</normal>
				<hover>
					<fill color='#DDDDDD' alpha='0.9' angle="90"/>
				</hover>
				<down>
					<fill color='#AAAAAA' alpha='0.3' angle="90"/>
				</down>
			</states>;
		
		private static const submitStyle:XML = 
			<label vAlign="center">
				<format color='555555' font='微软雅黑' size='12' letterSpacing="3"/>
			</label>;
	}
}