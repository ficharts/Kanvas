package commands
{
	import flash.geom.Point;
	
	import model.CoreFacade;
	import model.vo.ChartVO;
	import model.vo.ElementVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.ElementCreator;
	import util.LayoutUtil;
	import util.layout.LayoutTransformer;
	
	import view.element.chart.ChartElement;

	/**
	 *
	 * 创建图表
	 *  
	 * @author wanglei
	 * 
	 */	
	public class CreatChartCMD extends Command
	{
		public function CreatChartCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			//来自于工具面板触发的创建，
			var layoutTransformer:LayoutTransformer = CoreFacade.coreMediator.layoutTransformer;
			var point:Point = LayoutUtil.stagePointToElementPoint(layoutTransformer.canvas.stage.stageWidth / 2, 
				layoutTransformer.canvas.stage.stageHeight / 2, layoutTransformer.canvas);
			
			// VO 初始化
			var elementVO:ElementVO = 	ElementCreator.getElementVO('chart2d');
			
			elementVO.x = point.x;
			elementVO.y = point.y;
			elementVO.rotation = 0;
			elementVO.width = 400;
			elementVO.height = 300;
			elementVO.styleType = "chart";
			
			// UI 初始化
			element = new ChartElement(elementVO);
			
			// 新创建图形的比例总是与画布比例互补，保证任何时候创建的图形看起来是标准大小
			elementVO.scale = layoutTransformer.compensateScale;
			CoreFacade.addElement(element);
			
			//放置拖动创建时 当前原件未被指定 
			CoreFacade.coreMediator.currentElement = element;
			
			//开始缓动，将此设为false当播放完毕且鼠标弹起时进入选择状态
			CoreFacade.coreMediator.createNewShapeTweenOver = false;
			
			this.dataChanged();
		}
		
		/**
		 */		
		private var element:ChartElement;
	}
}