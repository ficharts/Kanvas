package commands
{
	import model.CoreFacade;
	
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import util.undoRedo.ICommand;

	/**
	 */	
	public class Command extends SimpleCommand implements ICommand
	{
		
		
		/**
		 * 设置为当前元素, 并且将其设置为选择状态 
		 */
		public static const SElECT_ELEMENT:String = "selectElement";
		
		/**
		 * 取消元素选择，将其切换为非选择状态，清空当前元素
		 */		
		public static const UN_SELECT_ELEMENT:String = 'unSelectElement';
		
		/**
		 * 自动剧中对齐画布
		 */		
		public static const AUTO_ZOOM:String = 'autoZoom';
		
		/**
		 * 移动元素
		 */
		public static const MOVE_ELEMENT:String = "moveElement";
		
		/**
		 * 缩放元素 
		 */		
		public static const SCALE_ELEMENT:String = 'scaleElement';
		
		/**
		 * 旋转元素 
		 */		
		public static const ROLL_ELEMENT:String = 'rollElement';
		
		/**
		 * 改变颜色
		 */	
		public static const CHANGE_ELEMENT_COLOR:String = "changeElementColor";
		
		/**
		 * 改变元素样式
		 */	
		public static const CHANGE_ELEMENT_STYLE:String = "changeElementStyle";
		
		/**
		 * 改变层级
		 */	
		public static const CHANGE_ELEMENT_LAYER:String = "changeElementLayer";
		
		/**
		 * 改变层级
		 */	
		public static const CHANGE_ELEMENT_PROPERTY:String = "changeElementProperty";
		
		
		/**
		 * 组合 
		 */		
		public static const TEM_TO_GROUP:String = 'temToGroup';
		
		/**
		 * 解组合 
		 */		
		public static const GROUP_TO_TEM:String = 'groupToTem';
		
		/**
		 * 撤销
		 */
		public static const UN_DO:String = "unDo";
		
		/**
		 * 重做， 反撤销
		 */		
		public static const RE_DO:String = "reDo";
		
		
		
		
		
		
		//----------------------------------------------------------
		
		
		/**
		 * 导入文件
		 */
		public static const IMPORT_DATA:String = "importData";
		
		/**
		 * 导出文件
		 */
		public static const EXPORT_DATA:String = "exportData";
		
		/**
		 * 保存图片
		 */
		public static const SAVE_IMAGE:String = "saveImage";
		
		/**
		 * 插入图片
		 */
		public static const INSERT_IMAGE:String = "insertImage";
		
		/**
		 * 创建形状
		 */
		public static const CREATE_SHAPE:String = "createShape";
		
		/**
		 * 创建图片
		 */
		public static const CREATE_IMAGE:String = "createImage";
		
		/**
		 * 创建页面
		 */
		public static const CREATE_PAGE:String = "createPage";
		
		/**
		 * 点击画布时，与创建文本框
		 */
		public static const PRE_CREATE_TEXT:String = "preCreateText";
		
		/**
		 * 创建文本
		 */
		public static const CREATE_TEXT:String = "createText";
		
		
		/**
		 * 删除图形, 线条和图片
		 */
		public static const DELETE_ElEMENT:String = "deleteElement";
		
		/**
		 * 删除文本 
		 */		
		public static const DELETE_TEXT:String = 'deleteText';
		
		/**
		 * 删除图片 
		 */		
		public static const DELETE_IMG:String = 'deleteIMG';
		
		/**
		 * 删除页面
		 */	
		public static const DELETE_PAGE:String = "deletePage";
		
		
		
		//---------------------------------------------------------
		
		/**
		 * 设置整体样式风格 
		 */		
		public static const CHANGE_THEME:String = 'changeTheme';
		
		/**
		 * 改变背景颜色
		 */
		public static const CHANGE_BG_COLOR:String = "changeBgColor";
		
		/**
		 * 预览背景色，新背景颜色信息不反馈至UI层
		 */		
		public static const PREVIEW_BG_COLOR:String = 'previewBgColor';
		
		/**
		 * 绘制背景色
		 */		
		public static const RENDER_BG_COLOR:String = 'renderBgColor';
		
		/**
		 * 改变背景图片 
		 */		
		public static const CHANGE_BG_IMG:String = 'changeBgImg';
		
		/**
		 * 删除背景图片 
		 */		
		public static const DELETE_BG_IMG:String = 'deleteBgImg';
		
		/**
		 * 删除临时组合的子元素
		 */		
		public static const DELETE_CHILD_IN_TEM_GROUP:String = 'delChildsInTemGroup';
		
		/**
		 * 页面转换为元素
		 */		
		public static const CONVERT_PAGE_2_ELEMENT:String = "convertPage2Element";
		
		
		/**
		 * 元素转换为页面
		 */		
		public static const CONVERT_ELEMENT_2_PAGE:String = "convertElement2Page";
		
		
		
		
		
		
		//----------------------------------元素的复制与粘贴------------------------------
		
		/**
		 * 拷贝元素
		 */
		public static const COPY_ELEMENT:String = "copyElement";
		
		/**
		 */		
		public static const CUT_ELEMENT:String = 'cutElement';
		
		/**
		 * 粘贴元素
		 */
		public static const PASTE_ELEMENT:String = "pasteElement";
		
		/**
		 */		
		public static const COPY_TEM_GROUP:String = 'copyTemGroup';
		
		/**
		 */		
		public static const COPY_GROUP:String = 'copyGroup';
		
		/**
		 */		
		public static const PASTE_TEM_GROUP:String = 'pastTemGroup';
		
		/**
		 */		
		public static const PAST_GROUP:String = 'pastGroup';
		
		public static const CHANGE_PAGE_INDEX:String = "changePageIndex";
		
		/**
		 */		
		public function Command()
		{
		}
		
		/**
		 * 有些命令关系到数据变动，需告知外部以便保存数据
		 */		
		protected function dataChanged():void
		{
			CoreFacade.coreMediator.mainUI.dispatchEvent(new KVSEvent(KVSEvent.DATA_CHANGED));
		}
		
		/**
		 */		
		public function undoHandler():void
		{
			
		}
		
		/**
		 */		
		public function redoHandler():void
		{
			
		}
		
		
	}
}