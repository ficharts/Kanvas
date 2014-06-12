package modules
{
	

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
			createPage (xml.descendants("s"));
			analyzeObj (xml["zui-table"].object);
			analyzePage();
			rearrangeID();
			return kanvas;
		}
		
		private function analyzeInit():void
		{
			kanvas = 
				<kanvas>
					<bg colorIndex='-1'/>
					<header version = {CoreApp.VER} styleID='style_1'/>
					<main/>
					<pages/>
				</kanvas>;
			fonts  = {};
			comman = {};
			custom = {};
			tempo  = [];
			countPage = countEle = 0;
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
							var d:Array = b[0].split(".");
							if (d.length > 1)
							{
								(custom[d[0]])
									? custom[d[0]][d[1]] = c
									: custom[d[0]] = c;
							}
							else
							{
								if (custom[b[0]])
								{
									for (var name:String in c)
										custom[b[0]][name] = c[name];
								}
								else
								{
									custom[b[0]] = c;
								}
							}
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
				kanvas.bg.@imgID = xml.background.layer[0].object.resource.id;
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
					var color:String = getColor(xml["@class"], type);
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
						case "textwithplaceholder":
							createObj(xml, "text", xml["@class"], color, true);
							break;
						case "image":
							createObj(xml, "image", "img", color);
							break;
						default:
							break;
					}
				}
			}
		}
		
		private function createObj(data:XML, type:String, style:String, color:String = "000000", template:Boolean = false):void
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
			xml.invisible = (data["@class"] == "invisible");
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
					convertText(xml, data, style, template);
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
		
		private function convertText(target:XML, source:XML, style:String, template:Boolean = false):void
		{
			if (template)
			{
				target.@width  = Math.abs(source.placeholder.@x * 2);
				target.@height = Math.abs(source.placeholder.@y * 2);
				target.@ifMutiLine = true;
				target.@font = "微软雅黑";
				target.appendChild(XML('<text><![CDATA[Click to add text]]></text>'));
			}
			else
			{
				var t:XMLList  = source.p;
				target.@width  = Math.abs(source.width);
				target.@height = Math.abs(source.height);
				target.@ifMutiLine = true;
				target.@font = "微软雅黑";
				var s:String = "";
				var color:String = t[0].text.@color;
				if (color != "" && color != " " && color != "undefined")
					target.@color = uint(Number(color)).toString(16);
				
				for each (var x:XML in t)
				{
					for each (var i:XML in x.text)
						s += i + "\n";
				}
				target.appendChild(XML('<text><![CDATA[' + s.substr(0, s.length - 1) + ']]></text>'));
			}
		}
		
		private function convertImage(target:XML, source:XML, style:String):void
		{
			var isSwf:Boolean = (String(source.resource.url).indexOf(".swf") > -1);
			target.@type = (isSwf) ? "swf" : "img";
			target.@url = source.resource.url;
			target.@imgID = source.resource.id;
		}
		
		private function getColor(style:String, type:String = null):String
		{
			var css:Object;
			var color:String = "#EEEEEE";
			switch (type)
			{
				case "bracket":
				case "roundrect":
				case "circle":
					if (custom["ZFrame"] && custom["ZFrame"][style])
						css = custom["ZFrame"][style];
					break;
				case "text":
					if (custom["ZLabel"] && custom["ZLabel"][style])
						css = custom["ZLabel"][style];
					break;
				default:
					
					break;
			}
			
			if(!css)
			{
				if (comman[style])
				{
					css = comman[style];
				}
				else
				{
					for (var name:String in comman)
					{
						if (name.indexOf(style) > -1)
						{
							css = comman[name];
							break;
						}
					}
				}
			}
			
			if(!css)
			{
				if (custom[style])
				{
					css = custom[style];
				}
				else
				{
					for (name in custom)
					{
						if (name.indexOf(style) > -1)
						{
							css = custom[name];
							break;
						}
					}
				}
			}
			
			if (css)
			{
				if (css.color)
					color = css.color;
				else if (css.gradStartColor)
					color = css.gradStartColor;
				else if (css.borderColor)
					color = css.borderColor;
				if (color.toLocaleLowerCase() == "#fff")
					color = "#ffffff";
			}
			
			return color;
		}
		
		private function createPage(data:XMLList):void
		{
			if (data)
			{
				for each (var xml:XML in data)
				{
					var pag:XML = <page/>;
					pag.@id        = ++countPage;
					pag.@type      = "page";
					pag.@styleType = "shape";
					pag.@styleID   = "Page";
					pag.@tempoID   = xml.eagle.@o;
					pag.@index     = pag.@id;
					tempo[tempo.length] = pag;
				}
			}
		}
		
		private function analyzePage():void
		{
			var count:int = 0;
			for each (var xml:XML in tempo)
			{
				var ele:XMLList = kanvas.main.children().(@id == xml.@tempoID);
				if (ele && ele.length() == 1)
				{
					count ++;
					xml.@x         = ele[0].@x;
					xml.@y         = ele[0].@y;
					xml.@width     = ele[0].@width;
					xml.@height    = ele[0].@height;
					xml.@scale     = ele[0].@scale;
					xml.@rotation  = ele[0].@rotation;
					xml.@elementID = ele[0].@id;
					kanvas.pages.appendChild(xml);
				}
			}
		}
		
		private function rearrangeID():void
		{
			var list:XMLList = kanvas.main[0].children();
			delete kanvas.main;
			var main:XML = <main/>;
			
			if (list)
			{
				for each (var xml:XML in list)
				{
					var id:String = "tempo" + ( ++ countEle);
					var temp:String = xml.@id;
					xml.@id = id;
					var page:XMLList = kanvas.pages.children().(@tempoID == temp);
					var l:int = page.length();
					if (xml.invisible == "false")
					{
						if (page && l > 0) 
						{
							page[0].@elementID = id;
							if (l > 1)
							{
								
								for (var i:int = 1; i < l; i++)
									delete page[i].@elementID;
							}
						}
						main.appendChild(xml);
					}
					else
					{
						for (i = 0; i < l; i++)
							delete page[i].@elementID;
					}
					delete xml.invisible;
				}
			}
			
			for each (xml in list)
				xml.@id = String(xml.@id).substr(5);
			
			for each (xml in kanvas.pages.children())
			{
				if (xml.@elementID && xml.@elementID != "")
					xml.@elementID = String(xml.@elementID).substr(5);
				else
					delete xml.@elementID;
			}
			
			kanvas.appendChild(main);
		}
		
		private var fonts :Object;
		private var comman:Object;
		private var custom:Object;
		private var tempo :Array;
		
		private var countPage :uint;
		private var countEle  :uint;
		
		private var kanvas:XML;
	}
}