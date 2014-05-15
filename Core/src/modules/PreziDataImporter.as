package modules
{
	import flash.geom.Point;
	
	import model.vo.ElementVO;

	public final class PreziDataImporter
	{
		private static const instance:PreziDataImporter = new PreziDataImporter;
		public function PreziDataImporter()
		{
			if (instance)
				throw new Error("SingleTon");
		}
		
		public static function convertData(xml:XML):XML
		{
			return instance.convertData(xml);
		}
		
		internal function convertData(xml:XML):XML
		{
			analyzeInit();
			analyzeCSS (xml.style.toString());
			analyzeHead(xml);
			analyzeObj (xml["zui-table"].object);
			analyzePage(xml.descendants("s"));
			rearrangeID();
			return kanvas;
		}
		
		private function analyzeInit():void
		{
			fonts  = {};
			comman = {};
			custom = {};
		}
		
		private function analyzeCSS(data:String):void
		{
			if (data)
			{
				data = data.split("\n").join("");
				data = data.split("\t").join("");
				data = data.split(" " ).join("");
				data = data.split(":" ).join("\":\"");
				var a:Array = data.split("}");
				a.pop();
				var l:uint  = a.length;
				for each (var i:String in a)
				{
					var b:Array  = i.split("{");
					var s:String = ("{\"" + b[1] + "\"}").split(";").join("\",\"");
					s = s.substr(0, s.length - 4) + "}";
					var c:Object = JSON.parse(s);
					var f:String = b[0].substr(0, 1);
					switch (f)
					{
						case "@":
							fonts[c["font-family"]] = c["font-family"];
							break;
						case ".":
							comman[b[0].substr(1)] = c;
							break;
						default:
							custom[b[0]] = c;
							break;
					}
				}
			}
		}
		
		private function analyzeHead(xml:XML):void
		{
			kanvas.header.@preziVersion = xml.version;
			if (xml.background.layer && xml.background.layer.length() > 0)
			{
				kanvas.bg.@imgID = ++countImage;
				kanvas.bg.@imgURL = xml.background.layer[0].object.resource.url;
			}
			if (custom["Background"])
			{
				kanvas.bg.@color = custom["Background"].gradStart;
			}
		}
		
		private function analyzeObj(data:XMLList):void
		{
			if (data)
			{
				for each (var xml:XML in data)
				{
					var type :String = (xml.@type == "button") ? xml.type : xml.@type;
					var style:String = (type == "shape") ? xml.geom.@type : type;
					var color:String = getColor(xml["@class"]);
					switch (type)
					{
						case "bracket":
						case "roundrect":
						case "invisible":
							createObj(xml, "rect", "Border", color);
							break;
						case "circle":
							createObj(xml, "circle", "Border", color);
							break;
						case "shape":
							switch (style) 
							{
								case "circle":
									createObj(xml, "circle", "Fill", color);
									break;
								case "line":
									createObj(xml, "line", "Border", color);
									break;
								case "arrow":
									createObj(xml, "arrowLine", "Border", color);
									break;
								case "poly":
									createObj(xml, (xml.geom.p.length() == 3) ? "stepTriangle" : "rect", "Fill", color);
									break;
							}
							break;
						case "text":
							createObj(xml, "text", xml["@class"], color);
							break;
						case "image":
							createObj(xml, "img", "img", color);
							break;
						default:
							break;
					}
				}
			}
		}
		
		private function getColor(type:String):String
		{
			var css:Object;
			for (var name:String in comman)
			{
				if (name.indexOf(type) > -1)
				{
					css = comman[name];
					break;
				}
			}
			if (!css)
			{
				for (name in custom)
				{
					if (name.indexOf(type) > -1)
					{
						css = custom[name];
						break;
					}
				}
			}
			if (css)
			{
				if (css.color)
					return css.color;
				else if (css.borderColor)
					return css.borderColor;
				else if (css.gradStartColor)
					return css.gradStartColor;
			}
			
			return "#000000";
		}
		
		private function createObj(data:XML, type:String, style:String, color:String = "000000"):void
		{
			var xml:XML = new XML("<" + type + "/>");
			xml.@id        = data.@id;
			xml.@type      = type;
			xml.@styleID   = style;
			xml.@styleType = (type == "text") ? type : style.toLowerCase();
			style = style.toLowerCase();
			
			xml.@x        = data.@x;
			xml.@y        = data.@y;
			xml.@scale    = data.@s;
			xml.@rotation = data.@r;
			xml.@color    = color;
			switch (type)
			{
				case "circle":
					convertCircle(xml, data, style);
					break;
				case "rect":
					convertRect(xml, data, style);
					break;
				case "stepTriangle":
					convertTriangle(xml, data, style);
					break;
				case "line":
					convertLine(xml, data, style);
					break;
				case "arrowLine":
					convertArrowline(xml, data, style);
					break;
				case "text":
					convertText(xml, data, style);
					break;
				case "img":
					convertImage(xml, data, style);
					break;
			}
			kanvas.main.appendChild(xml);
		}
		
		private function convertCircle(target:XML, source:XML, style:String):void
		{
			if (style == "border")
			{
				target.@width  = source.size.w;
				target.@height = source.size.h;
				target.@thickness = 8;
			}
			else if (style == "fill")
			{
				target.@width  = 2 * Number(source.geom.r);
				target.@height = target.@width;
			}
			else
			{
				throw new Error("Unsupport circle Style!");
			}
		}
		
		private function convertRect(target:XML, source:XML, style:String):void
		{
			if (style == "border")
			{
				target.@width  = source.size.w;
				target.@height = source.size.h;
				target.@thickness = 16;
			}
			else if (style == "fill")
			{
				target.@width  = Math.abs(source.geom.p[1].@x) * 2;
				target.@height = Math.abs(source.geom.p[1].@y) * 2;
			}
			else
			{
				throw new Error("Unsupport rect Style!");
			}
		}
		
		private function convertTriangle(target:XML, source:XML, style:String):void
		{
			if (style == "fill")
			{
				target.@width  = Math.abs(source.geom.p[1].@x) * 2;
				target.@height = Math.abs(source.geom.p[1].@y) * 2;
				target.@radius = source.geom.r;
			}
			else
			{
				throw new Error("Unsupport rect Style!");
			}
		}
		
		private function convertLine(target:XML, source:XML, style:String):void
		{
			if (style == "border")
			{
				var sp:Array = source.geom.sp.toString().split(" ");
				var ep:Array = source.geom.ep.toString().split(" ");
				target.@width     = Math.sqrt(Math.pow(sp[0] - ep[0], 2) + Math.pow(sp[1] - ep[1], 2));
				target.@height    = 12;
				target.@thickness = source.geom.t;
				if (source.geom.b)
					target.@arc = source.geom.b * .6;
			}
			else
			{
				throw new Error("Unsupport rect Style!");
			}
		}
		
		private function convertArrowline(target:XML, source:XML, style:String):void
		{
			if (style == "border")
			{
				var sp:Array = source.geom.sp.toString().split(" ");
				var ep:Array = source.geom.ep.toString().split(" ");
				target.@width     = Math.sqrt(Math.pow(sp[0] - ep[0], 2) + Math.pow(sp[1] - ep[1], 2));
				target.@height    = 12;
				target.@thickness = source.geom.t;
				if (source.geom.b)
					target.@arc = source.geom.b * .6;
			}
			else
			{
				throw new Error("Unsupport rect Style!");
			}
		}
		
		private function convertText(target:XML, source:XML, style:String):void
		{
			var t:XMLList = source.p;
			target.@width  = source.width;
			target.@height = source.height;
			target.@ifMutiLine = t.length() > 1;
			target.@font = "微软雅黑";
			var s:String = "";
			for each (var x:XML in t)
				s += x.text + "\n";
			//s = s.substr(-1);
			target.appendChild(XML('<text><![CDATA[' + s.substr(0, s.length - 1) + ']]></text>'));
		}
		
		private function convertImage(target:XML, source:XML, style:String):void
		{
			target.@url = source.resource.url;
			target.@imgID = ++countImage;
		}
		
		private function analyzePage(data:XMLList):void
		{
			if (data)
			{
				for each (var xml:XML in data)
				{
					var ele:XMLList = kanvas.main.children().(@id == xml.eagle.@o);
					if (ele && ele.length() == 1)
					{
						var pag:XML = <page/>;
						pag.@id        = ++countPage;
						pag.@x         = ele[0].@x;
						pag.@y         = ele[0].@y;
						pag.@width     = ele[0].@width;
						pag.@height    = ele[0].@height;
						pag.@scale     = ele[0].@scale;
						pag.@rotation  = ele[0].@rotation;
						pag.@elementID = ele[0].@id;
						pag.@index     = countPage;
						kanvas.pages.appendChild(pag);
					}
				}
			}
		}
		
		private function rearrangeID():void
		{
			for each (var xml:XML in kanvas.main.children())
			{
				var id:uint = ++countEle;
				var temp:String = xml.@id;
				xml.@id = id;
				var page:XMLList = kanvas.pages.children().(@elementID == temp);
				if (page && page.length() == 1)
					page[0].@elementID = id;
			}
		}
		
		private var fonts :Object;
		private var comman:Object;
		private var custom:Object;
		
		private var countImage:uint;
		private var countPage :uint;
		private var countEle  :uint;
		
		private var vos:Vector.<ElementVO>;
		
		private var kanvas:XML = 
			<kanvas>
				<bg/>
				<header version = {CoreApp.VER} styleID='style_1'/>
				<main/>
				<pages/>
			</kanvas>;
	}
}