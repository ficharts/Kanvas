package landray.kp.maps.mind
{
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	
	import landray.kp.maps.mind.model.TreeElementVO;
	import landray.kp.maps.mind.view.TreeElement;
	
	
	public class MindData
	{
		[Embed(source='Tree.xml', mimeType='application/octet-stream')]
		private static var ConfigXmlStyle:Class;
		/**
		 * 样式配置
		 **/
		public static var configStyle:XML = new XML(new ConfigXmlStyle);
		/**
		 * 一级树形样式
		 **/
		public static var firstTreeElementStyle:XML = new XML(configStyle.first).copy();
		/**
		 * 二级树形样式
		 **/
		public static var secondTreeElementStyle:XML = new XML(configStyle.second).copy();
		/**
		 * 三级树形样式
		 **/
		public static var thridTreeElementStyle:XML = new XML(configStyle.thrid).copy();
		
		/**
		 * 所有思维导图VO
		 **/
		public static var allTreeElementVOs:Vector.<TreeElementVO> = new Vector.<TreeElementVO>;
		/**
		 * 思维导图根元素
		 **/
		public static var NodeTreeElement:TreeElement = null;
		/**
		 * 最后层级
		 **/
		public static var lastLevel:uint = 0;
		
		public function MindData()
		{
			
		}
		/**
		 * 思维导图所有数据映射
		 */
		public function mindDataMapping(xml:XML):void
		{
			if (xml.@type == "auto") //服务器生成数据
			{
				allTreeElementVOs = new Vector.<TreeElementVO>();
				for each(var minditem:XML in xml.children())
				{
					var style:XML = XMLVOMapper.extendFrom(firstTreeElementStyle.copy(),minditem.copy());
					var vo:TreeElementVO = new TreeElementVO();
					vo.level = 1;
					lastLevel = 1;
					XMLVOMapper.fuck(style,vo);
					allTreeElementVOs.push(vo);
					fuckChild(minditem,vo);
				}
			}
		}
		public function fuckChild(xml:XML, vo:TreeElementVO):void
		{
			for (var i:int = 0; i < xml.children().length(); i++) 
			{
				var style:XML = XMLVOMapper.extendFrom(secondTreeElementStyle.copy(),xml.children()[i].copy());
				var childVO:TreeElementVO = new TreeElementVO();
				XMLVOMapper.fuck(style, childVO);
				vo.children.push(childVO);
				childVO.expand = false;
				childVO.father = vo;
				childVO.level = vo.level + 1;
				if(childVO.level > lastLevel)
					lastLevel = childVO.level;
				lastFuckChild(xml.children()[i], childVO);
			}
		}
		private function lastFuckChild(xml:XML, vo:TreeElementVO):void
		{
			for each(var item:XML in xml.children())
			{
				var style:XML = XMLVOMapper.extendFrom(thridTreeElementStyle.copy(),item.copy());
				var childVO:TreeElementVO = new TreeElementVO();
				XMLVOMapper.fuck(style,childVO);
				vo.children.push(childVO);
				childVO.expand = false;
				childVO.father = vo;
				childVO.level = vo.level + 1;
				if(childVO.level > lastLevel)
					lastLevel = childVO.level;
				lastFuckChild(item,childVO);
			}
		}
	}
}