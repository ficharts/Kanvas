package view.toolBar
{
	import com.kvs.ui.label.LabelUI;

	/**
	 * 页面动画效果编辑时的工具条
	 */	
	public class PageEditState extends ToolBarStateBS
	{
		public function PageEditState(toolbar:ToolBar)
		{
			super(toolbar);
		}
		
		/**
		 */		
		override public function init():void
		{
			this.ctner.visible = false;
			
			title.text = "点击页面中的原件，为其添加动画效果";
			title.styleXML = <label radius='0' vPadding='5' hPadding='5'>
									<format color='#eeeeee' font='华文细黑' size='12'/>
								  </label>
			title.render();
			
			this.ctner.addChild(title);
		}
		
		/**
		 */		
		override public function updateLayout():void
		{
			tb.renderBG();
			
			title.x = (tb.w - title.width) / 2;
			title.y = (tb.h - title.height) / 2;
			
		}
		
		/**
		 */		
		private var title:LabelUI = new LabelUI;
		
		/**
		 */		
		override public function toNomal():void
		{
			tb.currentState.ctner.visible = false;
			
			tb.currentState = tb.normalState;
			tb.currentState.ctner.visible = true;
		}
	}
}