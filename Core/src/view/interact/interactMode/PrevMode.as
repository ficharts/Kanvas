
package view.interact.interactMode
{
	import commands.Command;
	
	import flash.ui.Mouse;
	
	import model.vo.PageVO;
	
	import view.element.ElementBase;
	import view.element.chart.IPlayElement;
	import view.interact.CoreMediator;
	
	/**
	 * 预览模式
	 */	
	public class PrevMode extends ModeBase
	{
		public function PrevMode(mainMediator:CoreMediator)
		{
			super(mainMediator);
		}
		
		/**
		 */		
		override public function playElement():void
		{
			var elements:Vector.<ElementBase> = mainMediator.collisionDetection.elements;
			var ele:ElementBase;
			var curPage:ElementBase;
			
			var pages:Vector.<ElementBase> = new Vector.<ElementBase>;
			var players:Vector.<ElementBase> = new Vector.<ElementBase>;
				
			var curPageVO:PageVO = 	mainMediator.pageManager.currentPage;
			for each (ele in elements)
			{
				if (ele.isPage)
				{
					if (ele.pageVO == curPageVO)
						curPage = ele;
					
					pages.push(ele);
				}
				
				if (ele is IPlayElement)
					players.push(ele);
			}
			
			if (curPage)
			{
				var eleInPage:ElementBase;
				
				for each (ele in elements)
				{
					eleInPage = mainMediator.collisionDetection.ifElementIn(ele, curPage);
					
					//检测原件在页面内, 并且自身不是页面
					if (eleInPage)
						eleInPage.play();
				}
				
				curPage.play();
			}
			
			//没有在页面中的图表要播放
			for each (var chart:ElementBase in players)
			{
				var ifInPage:Object = false;
				
				for each (ele in pages)
					ifInPage = mainMediator.collisionDetection.ifElementIn(chart, ele);
				
				if (chart.isPage == false && !ifInPage)	
					chart.play();
			}
		}
		
		/**
		 */		
		override public function autoZoom():void
		{
			mainMediator.sendNotification(Command.AUTO_ZOOM);
		}
		
		/**
		 */		
		override public function toUnSelectedMode():void
		{
			mainMediator.currentMode = mainMediator.unSelectedMode;
			mainMediator.currentMode.drawShotFrame();
			
			mainMediator.coreApp.clearDrawMode();
			mainMediator.coreApp.prevDrawMode = false;
			returnFromPrevState();
			
			mainMediator.previewCliker.enable = false;
			mainMediator.mouseController.autoHide = false;
			Mouse.show();
			
			//从演播模式退出后，画布继续停留在演播的位置
		}
	}
}