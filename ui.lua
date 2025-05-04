-- // azox Library
local Library = {};
do
	Library = {
		Open = true;
		Themes = {
			["Default"] = {
				["Accent"] = Color3.fromRGB(74, 125, 255);
				["Dark Accent"] = Color3.fromRGB(5, 8, 16);
				["Text"] = Color3.fromRGB(255,255,255);
				["Dark Text"] = Color3.fromRGB(121, 122, 126);
				["Holder"] = Color3.fromRGB(3, 2, 3);
				["Top"] = Color3.fromRGB(6, 7, 10);
				["Un-Selected"] = Color3.fromRGB(5, 8, 16); -- 8, 9, 17
				["Selected"] = Color3.fromRGB(11,16,34);
				["Outline"] = Color3.fromRGB(25, 25, 25);
				["Circle"] = Color3.fromRGB(130, 134, 142);
			};
			["Red"] = {
				["Accent"] = Color3.fromRGB(255, 75, 78);
				["Dark Accent"] = Color3.fromRGB(16, 5, 5);
				["Text"] = Color3.fromRGB(255,255,255);
				["Dark Text"] = Color3.fromRGB(121, 122, 126);
				["Holder"] = Color3.fromRGB(3, 2, 2);
				["Top"] = Color3.fromRGB(10, 6, 6);
				["Un-Selected"] = Color3.fromRGB(17, 8, 8);
				["Selected"] = Color3.fromRGB(34, 11, 11);
				["Outline"] = Color3.fromRGB(25, 25, 25);
				["Circle"] = Color3.fromRGB(130, 134, 142);
			};
			["Purple"] = {
				["Accent"] = Color3.fromRGB(159, 75, 255);
				["Dark Accent"] = Color3.fromRGB(10, 5, 16);
				["Text"] = Color3.fromRGB(255,255,255);
				["Dark Text"] = Color3.fromRGB(121, 122, 126);
				["Holder"] = Color3.fromRGB(3, 2, 3);
				["Top"] = Color3.fromRGB(8, 6, 10);
				["Un-Selected"] = Color3.fromRGB(10, 5, 16); -- 8, 9, 17
				["Selected"] = Color3.fromRGB(23, 11, 34);
				["Outline"] = Color3.fromRGB(25, 25, 25);
				["Circle"] = Color3.fromRGB(130, 134, 142);
			};
		};
		Pages = {};
		Sections = {};
		Flags = {};
		UnNamedFlags = 0;
		ThemeObjects = {Objects = {}; Outlines = {}};
		Holder = nil;
		Watermark = nil;
		Keys = {
			[Enum.KeyCode.LeftShift] = "LShift",
			[Enum.KeyCode.RightShift] = "RShift",
			[Enum.KeyCode.LeftControl] = "LCtrl",
			[Enum.KeyCode.RightControl] = "RCtrl",
			[Enum.KeyCode.LeftAlt] = "LAlt",
			[Enum.KeyCode.RightAlt] = "RAlt",
			[Enum.KeyCode.CapsLock] = "Caps",
			[Enum.KeyCode.One] = "1",
			[Enum.KeyCode.Two] = "2",
			[Enum.KeyCode.Three] = "3",
			[Enum.KeyCode.Four] = "4",
			[Enum.KeyCode.Five] = "5",
			[Enum.KeyCode.Six] = "6",
			[Enum.KeyCode.Seven] = "7",
			[Enum.KeyCode.Eight] = "8",
			[Enum.KeyCode.Nine] = "9",
			[Enum.KeyCode.Zero] = "0",
			[Enum.KeyCode.KeypadOne] = "Num1",
			[Enum.KeyCode.KeypadTwo] = "Num2",
			[Enum.KeyCode.KeypadThree] = "Num3",
			[Enum.KeyCode.KeypadFour] = "Num4",
			[Enum.KeyCode.KeypadFive] = "Num5",
			[Enum.KeyCode.KeypadSix] = "Num6",
			[Enum.KeyCode.KeypadSeven] = "Num7",
			[Enum.KeyCode.KeypadEight] = "Num8",
			[Enum.KeyCode.KeypadNine] = "Num9",
			[Enum.KeyCode.KeypadZero] = "Num0",
			[Enum.KeyCode.Minus] = "-",
			[Enum.KeyCode.Equals] = "=",
			[Enum.KeyCode.Tilde] = "~",
			[Enum.KeyCode.LeftBracket] = "[",
			[Enum.KeyCode.RightBracket] = "]",
			[Enum.KeyCode.RightParenthesis] = ")",
			[Enum.KeyCode.LeftParenthesis] = "(",
			[Enum.KeyCode.Semicolon] = ",",
			[Enum.KeyCode.Quote] = "'",
			[Enum.KeyCode.BackSlash] = "\\",
			[Enum.KeyCode.Comma] = ",",
			[Enum.KeyCode.Period] = ".",
			[Enum.KeyCode.Slash] = "/",
			[Enum.KeyCode.Asterisk] = "*",
			[Enum.KeyCode.Plus] = "+",
			[Enum.KeyCode.Period] = ".",
			[Enum.KeyCode.Backquote] = "`",
			[Enum.UserInputType.MouseButton1] = "MB1",
			[Enum.UserInputType.MouseButton2] = "MB2",
			[Enum.UserInputType.MouseButton3] = "MB3"
		};
		Connections = {};
		FontSize = 12;
		KeyList = nil;
		UIKey = Enum.KeyCode.End;
		ScreenGUI = nil;
		Typing = false;
		CurrentColor = nil;
	}

	-- // Ignores
	local Flags = {}; -- Ignore
	local Dropdowns = {}; -- Ignore
	local Pickers = {}; -- Ignore
	local VisValues = {}; -- Ignore
	Library.Theme = table.clone(Library.Themes["Default"]);
	
	-- // Extension
	Library.__index = Library
	Library.Pages.__index = Library.Pages
	Library.Sections.__index = Library.Sections
	local LocalPlayer = game:GetService('Players').LocalPlayer;
	local Mouse = LocalPlayer:GetMouse();
	local TweenService = game:GetService("TweenService");
	
	-- // Misc Functions
	do
		function Library:Connection(Signal, Callback)
			local Con = Signal:Connect(Callback)
			return Con
		end
		--
		function Library:Disconnect(Connection)
			Connection:Disconnect()
		end
		--
		function Library:Round(Number, Float)
			return Float * math.floor(Number / Float)
		end
		--
		function Library.NextFlag()
			Library.UnNamedFlags = Library.UnNamedFlags + 1
			return string.format("%.14g", Library.UnNamedFlags)
		end
		--
		function Library:RGBA(r, g, b, alpha)
			local rgb = Color3.fromRGB(r, g, b)
			local mt = table.clone(getrawmetatable(rgb))

			setreadonly(mt, false)
			local old = mt.__index

			mt.__index = newcclosure(function(self, key)
				if key:lower() == "transparency" then
					return alpha
				end

				return old(self, key)
			end)

			setrawmetatable(rgb, mt)

			return rgb
		end
		--
		function Library:GetConfig()
			local Config = ""
			for Index, Value in pairs(self.Flags) do
				if
					Index ~= "ConfigConfig_List"
					and Index ~= "ConfigConfig_Load"
					and Index ~= "ConfigConfig_Save"
				then
					local Value2 = Value
					local Final = ""
					--
					if typeof(Value2) == "Color3" then
						local hue, sat, val = Value2:ToHSV()
						--
						Final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, 1)
					elseif typeof(Value2) == "table" and Value2.Color and Value2.Transparency then
						local hue, sat, val = Value2.Color:ToHSV()
						--
						Final = ("rgb(%s,%s,%s,%s)"):format(hue, sat, val, Value2.Transparency)
					elseif typeof(Value2) == "table" and Value.Mode then
						local Values = Value.current
						--
						Final = ("key(%s,%s,%s)"):format(Values[1] or "nil", Values[2] or "nil", Value.Mode)
					elseif Value2 ~= nil then
						if typeof(Value2) == "boolean" then
							Value2 = ("bool(%s)"):format(tostring(Value2))
						elseif typeof(Value2) == "table" then
							local New = "table("
							--
							for Index2, Value3 in pairs(Value2) do
								New = New .. Value3 .. ","
							end
							--
							if New:sub(#New) == "," then
								New = New:sub(0, #New - 1)
							end
							--
							Value2 = New .. ")"
						elseif typeof(Value2) == "string" then
							Value2 = ("string(%s)"):format(Value2)
						elseif typeof(Value2) == "number" then
							Value2 = ("number(%s)"):format(Value2)
						end
						--
						Final = Value2
					end
					--
					Config = Config .. Index .. ": " .. tostring(Final) .. "\n"
				end
			end
			--
			return Config
		end
		--
		function Library:LoadConfig(Config)
			local Table = string.split(Config, "\n")
			local Table2 = {}
			for Index, Value in pairs(Table) do
				local Table3 = string.split(Value, ":")
				--
				if Table3[1] ~= "ConfigConfig_List" and #Table3 >= 2 then
					local Value = Table3[2]:sub(2, #Table3[2])
					--
					if Value:sub(1, 3) == "rgb" then
						local Table4 = string.split(Value:sub(5, #Value - 1), ",")
						--
						Value = Table4
					elseif Value:sub(1, 3) == "key" then
						local Table4 = string.split(Value:sub(5, #Value - 1), ",")
						--
						if Table4[1] == "nil" and Table4[2] == "nil" then
							Table4[1] = nil
							Table4[2] = nil
						end
						--
						Value = Table4
					elseif Value:sub(1, 4) == "bool" then
						local Bool = Value:sub(6, #Value - 1)
						--
						Value = Bool == "true"
					elseif Value:sub(1, 5) == "table" then
						local Table4 = string.split(Value:sub(7, #Value - 1), ",")
						--
						Value = Table4
					elseif Value:sub(1, 6) == "string" then
						local String = Value:sub(8, #Value - 1)
						--
						Value = String
					elseif Value:sub(1, 6) == "number" then
						local Number = tonumber(Value:sub(8, #Value - 1))
						--
						Value = Number
					end
					--
					Table2[Table3[1]] = Value
				end
			end
			--
			for i, v in pairs(Table2) do
				if Flags[i] then
					if typeof(Flags[i]) == "table" then
						Flags[i]:Set(v)
					else
						Flags[i](v)
					end
				end
			end
		end
		--
		function Library:SetOpen(bool)
			if typeof(bool) == 'boolean' then
				Library.Open = bool;
				Library.Holder.Visible = bool;
			end
		end;
		--
		function Library:LoadTheme(Theme)
			Library.Theme = table.clone(Library.Themes[Theme])

			for Index, Value in pairs(Library.ThemeObjects.Objects) do
				Library:ChangeObjectTheme(Index, Value);
			end;
		end;
		--
		function Library:ChangeObjectTheme(Object, Color, Tween, TweenInf)
			Library.ThemeObjects.Objects[Object] = Color
			if Tween then
				if Object:IsA("Frame") or Object:IsA("TextButton") or Object:IsA("ScrollingFrame") then
					TweenService:Create(Object, TweenInf, {BackgroundColor3 = Library.Theme[Color]}):Play()
					if Object:IsA("ScrollingFrame") then
						Object.ScrollBarImageColor3 = Library.Theme["Accent"]
					end
				elseif Object:IsA("TextLabel") or Object:IsA("TextBox") then
					TweenService:Create(Object, TweenInf, {TextColor3 = Library.Theme[Color]}):Play()
				elseif Object:IsA("ImageLabel") then
					TweenService:Create(Object, TweenInf, {ImageColor3 = Library.Theme[Color]}):Play();
				elseif Object:IsA("UIStroke") then
					TweenService:Create(Object, TweenInf, {Color = Library.Theme[Color]}):Play()
				end
			else
				if Object:IsA("Frame") or Object:IsA("TextButton") or Object:IsA("ScrollingFrame") then
					Object.BackgroundColor3 = Library.Theme[Color];
					if Object:IsA("ScrollingFrame") then
						Object.ScrollBarImageColor3 = Library.Theme["Accent"]
					end
				elseif Object:IsA("TextLabel") or Object:IsA("TextBox") then
					Object.TextColor3 = Library.Theme[Color];
				elseif Object:IsA("ImageLabel") then
					Object.ImageColor3 = Library.Theme[Color];
				elseif Object:IsA("UIStroke") then
					Object.Color = Library.Theme[Color];
				end
			end
		end;
		--
		function Library:ChangeThemeColor(Option, Color)
			self.Theme[Option] = Color

			for obj, theme in next, Library.ThemeObjects.Objects do
				if theme == Option then
					if obj:IsA("Frame") or obj:IsA("TextButton") or obj:IsA("ScrollingFrame") then
						obj.BackgroundColor3 = Color;
						if obj:IsA("ScrollingFrame") then
							obj.ScrollBarImageColor3 = Library.Theme["Accent"]
						end
					elseif obj:IsA("TextLabel") or obj:IsA("TextBox") then
						obj.TextColor3 = Color;
					elseif obj:IsA("ImageLabel") then
						obj.ImageColor3 = Color;
					elseif obj:IsA("UIStroke") then
						obj.Color = Color;
					end
				end
			end
		end;
		--
		function Library:IsMouseOverFrame(Frame)
			local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

			if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
				and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then

				return true;
			end;
		end;
	end;
	
	-- // Colorpicker Element
	do
		function Library:NewPicker(name, default, defaultalpha, parent, count, flag, callback)
			-- // Instances
			local Box = Instance.new("TextButton")
			local BoxCorner = Instance.new("UICorner")
			local ModeBox = Library:NewInstance("Frame", false, "Un-Selected")
			local ModeCorner = Instance.new("UICorner")
			local Color = Instance.new("TextButton")
			local Sat = Instance.new("ImageLabel")
			local ColorCorner = Instance.new("UICorner")
			local Val = Instance.new("ImageLabel")
			local ColorCorner_2 = Instance.new("UICorner")
			local Hue = Instance.new("ImageButton")
			local HueCorner = Instance.new("UICorner")
			local HueCircle = Instance.new("Frame")
			local CircleCorner = Instance.new("UICorner")
			local Trans = Instance.new("TextButton")
			local TransCorner = Instance.new("UICorner")
			local UIGradient = Instance.new("UIGradient")
			local TransCircle = Instance.new("Frame")
			local CircleCorner_2 = Instance.new("UICorner")
			local Pointer = Instance.new("Frame")
			local PointerStroke = Instance.new("UIStroke")
			local PointerCorner = Instance.new("UICorner")
			--
			Box.Name = "Box"
			Box.Parent = parent
			Box.BackgroundColor3 = default
			Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Box.BorderSizePixel = 0
			Box.Position = UDim2.new(1, - (count * 18) - (count * 6), 0, 0)
			Box.Size = UDim2.new(0, 18, 1, 0)
			Box.AutoButtonColor = false
			Box.Text = ""

			BoxCorner.CornerRadius = UDim.new(1, 0)
			BoxCorner.Name = "BoxCorner"
			BoxCorner.Parent = Box

			ModeBox.Name = "ModeBox"
			ModeBox.Parent = Library.ScreenGUI
			ModeBox.AnchorPoint = Vector2.new(0, 0.5)
			ModeBox.BackgroundColor3 = Color3.fromRGB(8, 9, 17)
			ModeBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ModeBox.BorderSizePixel = 0
			ModeBox.Position = UDim2.new(0, Box.AbsolutePosition.X + 100, 0, Box.AbsolutePosition.Y)
			ModeBox.Size = UDim2.new(0, 150, 0, 170)
			ModeBox.Visible = false
			ModeBox.ZIndex = 100

			ModeCorner.CornerRadius = UDim.new(0, 4)
			ModeCorner.Name = "ModeCorner"
			ModeCorner.Parent = ModeBox

			Color.Name = "Color"
			Color.Parent = ModeBox
			Color.BackgroundColor3 = default
			Color.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Color.BorderSizePixel = 0
			Color.Position = UDim2.new(0, 10, 0, 10)
			Color.Size = UDim2.new(0, 130, 0, 120)
			Color.AutoButtonColor = false
			Color.Font = Enum.Font.SourceSans
			Color.Text = ""
			Color.TextColor3 = Color3.fromRGB(0, 0, 0)
			Color.TextSize = 14.000

			Sat.Name = "Sat"
			Sat.Parent = Color
			Sat.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Sat.BackgroundTransparency = 1.000
			Sat.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Sat.BorderSizePixel = 0
			Sat.Size = UDim2.new(1, 0, 1, 0)
			Sat.Image = "http://www.roblox.com/asset/?id=14684562507"
			
			Pointer.Name = "Pointer"
			Pointer.Parent = Color
			Pointer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Pointer.BackgroundTransparency = 1.000
			Pointer.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Pointer.BorderSizePixel = 0
			Pointer.Size = UDim2.new(0,8,0,8)
			Pointer.ZIndex = 2
			
			PointerCorner.CornerRadius = UDim.new(1,0)
			PointerCorner.Name = "ModeCorner"
			PointerCorner.Parent = Pointer
			
			PointerStroke.Parent = Pointer
			PointerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			PointerStroke.Thickness = 1
			PointerStroke.LineJoinMode = Enum.LineJoinMode.Round
			PointerStroke.Color = Color3.fromRGB(255,255,255)

			ColorCorner.CornerRadius = UDim.new(0, 4)
			ColorCorner.Name = "ColorCorner"
			ColorCorner.Parent = Sat

			Val.Name = "Val"
			Val.Parent = Color
			Val.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Val.BackgroundTransparency = 1.000
			Val.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Val.BorderSizePixel = 0
			Val.Size = UDim2.new(1, 0, 1, 0)
			Val.Image = "http://www.roblox.com/asset/?id=14684563800"

			ColorCorner_2.CornerRadius = UDim.new(0, 4)
			ColorCorner_2.Name = "ColorCorner"
			ColorCorner_2.Parent = Color

			Hue.Name = "Hue"
			Hue.Parent = Color
			Hue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Hue.BackgroundTransparency = 1.000
			Hue.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Hue.BorderSizePixel = 0
			Hue.Position = UDim2.new(0, 0, 1, 10)
			Hue.Size = UDim2.new(1, 0, 0, 6)
			Hue.Image = "http://www.roblox.com/asset/?id=16789872274"

			HueCorner.CornerRadius = UDim.new(1, 0)
			HueCorner.Name = "Hue Corner"
			HueCorner.Parent = Hue

			HueCircle.Name = "HueCircle"
			HueCircle.Parent = Hue
			HueCircle.AnchorPoint = Vector2.new(0, 0.5)
			HueCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
			HueCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			HueCircle.BorderSizePixel = 0
			HueCircle.Position = UDim2.new(0, 0, 0.5, 0)
			HueCircle.Size = UDim2.new(0, 12, 0, 12)

			CircleCorner.CornerRadius = UDim.new(1, 0)
			CircleCorner.Name = "CircleCorner"
			CircleCorner.Parent = HueCircle

			Trans.Name = "Trans"
			Trans.Parent = Color
			Trans.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
			Trans.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Trans.BorderSizePixel = 0
			Trans.Position = UDim2.new(0, 0, 1, 25)
			Trans.Size = UDim2.new(1, 0, 0, 6)
			Trans.AutoButtonColor = false
			Trans.Font = Enum.Font.SourceSans
			Trans.Text = ""
			Trans.TextColor3 = Color3.fromRGB(0, 0, 0)
			Trans.TextSize = 14.000

			TransCorner.CornerRadius = UDim.new(1, 0)
			TransCorner.Name = "TransCorner"
			TransCorner.Parent = Trans

			UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))}
			UIGradient.Parent = Trans

			TransCircle.Name = "TransCircle"
			TransCircle.Parent = Trans
			TransCircle.AnchorPoint = Vector2.new(0, 0.5)
			TransCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
			TransCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TransCircle.BorderSizePixel = 0
			TransCircle.Position = UDim2.new(0, 0, 0.5, 0)
			TransCircle.Size = UDim2.new(0, 12, 0, 12)

			CircleCorner_2.CornerRadius = UDim.new(1, 0)
			CircleCorner_2.Name = "CircleCorner"
			CircleCorner_2.Parent = TransCircle

			-- // Connections
			local mouseover = false
			local hue, sat, val = default:ToHSV()
			local hsv = default:ToHSV()
			local alpha = defaultalpha
			local oldcolor = hsv
			local slidingsaturation = false
			local slidinghue = false
			local slidingalpha = false

			local function update()
				local real_pos = game:GetService("UserInputService"):GetMouseLocation()
				local mouse_position = Vector2.new(real_pos.X - 5, real_pos.Y - 30)
				local relative_palette = (mouse_position - Color.AbsolutePosition)
				local relative_hue     = (mouse_position - Hue.AbsolutePosition)
				local relative_opacity = (mouse_position - Trans.AbsolutePosition)
				--
				if slidingsaturation then
					sat = math.clamp(1 - relative_palette.X / Color.AbsoluteSize.X, 0, 1)
					val = math.clamp(1 - relative_palette.Y / Color.AbsoluteSize.Y, 0, 1)
				elseif slidinghue then
					hue = math.clamp(relative_hue.X / Hue.AbsoluteSize.X, 0, 1)
				elseif slidingalpha then
					alpha = math.clamp(relative_opacity.X / Trans.AbsoluteSize.X, 0, 1)
				end

				hsv = Color3.fromHSV(hue, sat, val)
				TweenService:Create(Pointer, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(1 - sat, 0.000, 0.910), 0, math.clamp(1 - val, 0.000, 0.910), 0)}):Play()
				Color.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
				Trans.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
				HueCircle.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
				TransCircle.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
				Box.BackgroundColor3 = hsv
				
				TweenService:Create(HueCircle, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(hue, 0.000, 0.905),0,0.5,0)}):Play()
				TweenService:Create(TransCircle, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(alpha, 0.000, 0.905),0,0.5,0)}):Play()

				if flag then
					Library.Flags[flag] = Library:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha)
				end

				callback(Library:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha))
			end

			local function set(color, a)
				if type(color) == "table" then
					a = color[4]
					color = Color3.fromHSV(color[1], color[2], color[3])
				end
				if type(color) == "string" then
					color = Color3.fromHex(color)
				end

				local oldcolor = hsv
				local oldalpha = alpha

				hue, sat, val = color:ToHSV()
				alpha = a or 1
				hsv = Color3.fromHSV(hue, sat, val)

				if hsv ~= oldcolor then
					Box.BackgroundColor3 = hsv
					Color.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
					HueCircle.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
					TransCircle.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
					TweenService:Create(Pointer, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(1 - sat, 0.000, 0.910), 0, math.clamp(1 - val, 0.000, 0.910), 0)}):Play()
					Trans.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
					TweenService:Create(HueCircle, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(hue, 0.000, 0.905),0,0.5,0)}):Play()
					TweenService:Create(TransCircle, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(alpha, 0.000, 0.905),0,0.5,0)}):Play()

					if flag then
						Library.Flags[flag] = Library:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha)
					end

					callback(Library:RGBA(hsv.r * 255, hsv.g * 255, hsv.b * 255, alpha))
				end
			end

			Flags[flag] = set

			set(default, defaultalpha)

			Sat.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidingsaturation = true
					update()
				end
			end)

			Sat.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidingsaturation = false
					update()
				end
			end)

			Hue.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidinghue = true
					update()
				end
			end)

			Hue.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidinghue = false
					update()
				end
			end)

			Trans.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidingalpha = true
					update()
				end
			end)

			Trans.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					slidingalpha = false
					update()
				end
			end)

			Library:Connection(game:GetService("UserInputService").InputChanged, function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					if slidingalpha then
						update()
					end

					if slidinghue then
						update()
					end

					if slidingsaturation then
						update()
					end
				end
			end)

			Box.MouseButton1Down:Connect(function()
				ModeBox.Visible = true
				parent.ZIndex = 3
				ModeBox.Position = UDim2.new(0, Box.AbsolutePosition.X + 50, 0, Box.AbsolutePosition.Y)

				if slidinghue then
					slidinghue = false
				end

				if slidingsaturation then
					slidingsaturation = false
				end

				if slidingalpha then
					slidingalpha = false
				end
			end)
			--
			Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
				if ModeBox.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not Library:IsMouseOverFrame(ModeBox) and not Library:IsMouseOverFrame(Box) then
						ModeBox.Visible = false
						parent.ZIndex = 1
					end
				end
			end)

			local colorpickertypes = {}

			function colorpickertypes:Set(color, newalpha)
				set(color, newalpha)
			end

			return colorpickertypes, ModeBox
		end
	end
	
	function Library:NewInstance(Inst, Ignore, Theme)
		local Obj = Instance.new(Inst)
		if not Ignore then
			if Theme then
				Library.ThemeObjects.Objects[Obj] = Theme;
				if Obj:IsA("Frame") or Obj:IsA("TextButton") or Obj:IsA("ScrollingFrame") then
					Obj.BackgroundColor3 = Library.Theme[Theme];
					if Obj:IsA("ScrollingFrame") then
						Obj.ScrollBarImageColor3 = Library.Theme["Accent"]
					end
				elseif Obj:IsA("TextLabel") or Obj:IsA("TextBox") then
					Obj.TextColor3 = Library.Theme[Theme];
				elseif Obj:IsA("ImageLabel") then
					Obj.ImageColor3 = Library.Theme[Theme];
				elseif Obj:IsA("UIStroke") then
					Obj.Color = Library.Theme[Theme];
				end;
			end;
		end;
		return Obj;
	end;
	
	-- // Library Functions
	do
		local Pages = Library.Pages;
		local Sections = Library.Sections;
		--
		function Library:Window(Options)
			local Window = {
				Pages = {};
				Sections = {};
				Elements = {};
				Dragging = { false, UDim2.new(0, 0, 0, 0) };
				Size = Options.Size or Options.size or UDim2.new(0, 680, 0, 500);
				Name = Options.name or Options.Name or "EVOLUTION";
			};
			--
			local EvolutionGUI = Instance.new("ScreenGui")
			local Holder = Library:NewInstance("Frame", true)
			local HoldCorner = Library:NewInstance("UICorner", true)
			local Inner = Library:NewInstance("Frame", false, "Holder")
			local InnerCorner = Library:NewInstance("UICorner", true)
			local Thing = Library:NewInstance("Frame", false, "Holder")
			local Top = Library:NewInstance("Frame", false, "Top")
			local TopCorner = Library:NewInstance("UICorner", true)
			local TopThing = Library:NewInstance("Frame", false, "Top")
			local TopBottom = Library:NewInstance("Frame", false, "Top")
			local Save = Library:NewInstance("TextButton", false, "Un-Selected")
			local SaveCorner = Library:NewInstance("UICorner", true)
			local SaveTitle = Library:NewInstance("TextLabel", false, "Dark Text")
			local SaveIcon = Library:NewInstance("ImageButton", true)
			local Load = Library:NewInstance("TextButton",false, "Un-Selected")
			local LoadCorner = Library:NewInstance("UICorner", true)
			local LoadTitle = Library:NewInstance("TextLabel", false, "Dark Text")
			local LoadIcon = Library:NewInstance("ImageButton", true)
			local Title1 = Library:NewInstance("TextLabel", false, "Text")
			local Title2 = Library:NewInstance("TextLabel", false, "Accent")
			local UserIcon = Library:NewInstance("ImageLabel", true)
			local IconCorner = Library:NewInstance("UICorner", true)
			local UserName = Library:NewInstance("TextLabel",false, "Text")
			local Expires = Library:NewInstance("TextLabel", false, "Accent")
			local Till = Library:NewInstance("TextLabel", false, "Dark Text")
			local Tabs = Library:NewInstance("Frame", true)
			local UIListLayout = Library:NewInstance("UIListLayout", true)
			local DragButton = Instance.new("TextButton", Holder)
			local Stroke1 = Library:NewInstance("UIStroke", false, "Outline")
			local Stroke2 = Library:NewInstance("UIStroke", false, "Outline")
			
			EvolutionGUI.Name = "EvolutionGUI"
			EvolutionGUI.Parent = game.CoreGui
			EvolutionGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			Library.ScreenGUI = EvolutionGUI
			
			Stroke1.Parent = Save
			Stroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			Stroke1.Thickness = 1
			Stroke1.LineJoinMode = Enum.LineJoinMode.Round
			
			Stroke2.Parent = Load
			Stroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			Stroke2.Thickness = 1
			Stroke2.LineJoinMode = Enum.LineJoinMode.Round
			
			
			DragButton.Name = "DragButton"
			DragButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DragButton.BackgroundTransparency = 1.000
			DragButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DragButton.BorderSizePixel = 0
			DragButton.Size = UDim2.new(1, 0, 1, 0)
			DragButton.AutoButtonColor = false
			DragButton.Font = Enum.Font.SourceSans
			DragButton.TextColor3 = Color3.fromRGB(0, 0, 0)
			DragButton.TextSize = 14.000

			Holder.Name = "Holder"
			Holder.Parent = EvolutionGUI
			Holder.AnchorPoint = Vector2.new(0.5, 0.5)
			Holder.BackgroundColor3 = Color3.fromRGB(3, 6, 11)
			Holder.BackgroundTransparency = 0.200
			Holder.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Holder.BorderSizePixel = 0
			Holder.Position = UDim2.new(0.5, 0, 0.5, 0)
			Holder.Size = Window.Size
			Holder.ZIndex = 100
			Library.Holder = Holder

			HoldCorner.Name = "HoldCorner"
			HoldCorner.Parent = Holder

			Inner.Name = "Inner"
			Inner.Parent = Holder
			Inner.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Inner.BorderSizePixel = 0
			Inner.Position = UDim2.new(0, 200, 0, 0)
			Inner.Size = UDim2.new(1, -200, 1, 0)
			Inner.ZIndex = 101

			InnerCorner.Name = "InnerCorner"
			InnerCorner.Parent = Inner

			Thing.Name = "Thing"
			Thing.Parent = Inner
			Thing.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Thing.BorderSizePixel = 0
			Thing.Size = UDim2.new(0, 5, 1, 0)

			Top.Name = "Top"
			Top.Parent = Inner
			Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Top.BorderSizePixel = 0
			Top.Size = UDim2.new(1, 0, 0, 60)
			Top.ZIndex = 2

			TopCorner.Name = "TopCorner"
			TopCorner.Parent = Top

			TopThing.Name = "TopThing"
			TopThing.Parent = Top
			TopThing.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TopThing.BorderSizePixel = 0
			TopThing.Size = UDim2.new(0, 5, 1, 0)

			TopBottom.Name = "TopBottom"
			TopBottom.Parent = Top
			TopBottom.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TopBottom.BorderSizePixel = 0
			TopBottom.Position = UDim2.new(0, 0, 1, -2)
			TopBottom.Size = UDim2.new(1, 0, 0, 2)

			Save.Name = "Save"
			Save.Parent = Top
			Save.AnchorPoint = Vector2.new(0, 0.5)
			Save.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Save.BorderSizePixel = 0
			Save.Position = UDim2.new(0, 20, 0.5, 0)
			Save.Size = UDim2.new(0, 100, 0, 25)
			Save.ZIndex = 3
			Save.AutoButtonColor = false
			Save.Font = Enum.Font.SourceSans
			Save.Text = ""
			Save.TextColor3 = Color3.fromRGB(102, 103, 106)
			Save.TextSize = 14.000

			SaveCorner.CornerRadius = UDim.new(0, 4)
			SaveCorner.Name = "SaveCorner"
			SaveCorner.Parent = Save

			SaveTitle.Name = "SaveTitle"
			SaveTitle.Parent = Save
			SaveTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SaveTitle.BackgroundTransparency = 1.000
			SaveTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SaveTitle.BorderSizePixel = 0
			SaveTitle.Position = UDim2.new(0, 18, 0, 0)
			SaveTitle.Size = UDim2.new(1, -25, 1, 0)
			SaveTitle.Font = Enum.Font.SourceSans
			SaveTitle.Text = "Save"
			SaveTitle.TextSize = 14.000
			SaveTitle.TextStrokeTransparency = 1

			SaveIcon.Name = "SaveIcon"
			SaveIcon.Parent = Save
			SaveIcon.AnchorPoint = Vector2.new(0.5, 0.5)
			SaveIcon.BackgroundTransparency = 1.000
			SaveIcon.Position = UDim2.new(0.5, -20, 0.5, 0)
			SaveIcon.Size = UDim2.new(0, 20, 0, 20)
			SaveIcon.ZIndex = 2
			SaveIcon.Image = "rbxassetid://6764432408"
			SaveIcon.ImageRectOffset = Vector2.new(100, 100)
			SaveIcon.ImageRectSize = Vector2.new(50, 50)
			SaveIcon.ImageTransparency = 0.400

			Load.Name = "Load"
			Load.Parent = Top
			Load.AnchorPoint = Vector2.new(0, 0.5)
			Load.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Load.BorderSizePixel = 0
			Load.Position = UDim2.new(0, 140, 0.5, 0)
			Load.Size = UDim2.new(0, 100, 0, 25)
			Load.ZIndex = 3
			Load.AutoButtonColor = false
			Load.Font = Enum.Font.SourceSans
			Load.Text = ""
			Load.TextSize = 14.000

			LoadCorner.CornerRadius = UDim.new(0, 4)
			LoadCorner.Name = "LoadCorner"
			LoadCorner.Parent = Load

			LoadTitle.Name = "LoadTitle"
			LoadTitle.Parent = Load
			LoadTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			LoadTitle.BackgroundTransparency = 1.000
			LoadTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			LoadTitle.BorderSizePixel = 0
			LoadTitle.Position = UDim2.new(0, 18, 0, 0)
			LoadTitle.Size = UDim2.new(1, -25, 1, 0)
			LoadTitle.Font = Enum.Font.SourceSans
			LoadTitle.Text = "Load"
			LoadTitle.TextSize = 14.000
			LoadTitle.TextStrokeTransparency = 1

			LoadIcon.Name = "LoadIcon"
			LoadIcon.Parent = Load
			LoadIcon.AnchorPoint = Vector2.new(0.5, 0.5)
			LoadIcon.BackgroundTransparency = 1.000
			LoadIcon.Position = UDim2.new(0.5, -20, 0.5, 0)
			LoadIcon.Size = UDim2.new(0, 20, 0, 20)
			LoadIcon.ZIndex = 2
			LoadIcon.Image = "rbxassetid://6764432293"
			LoadIcon.ImageRectOffset = Vector2.new(0, 900)
			LoadIcon.ImageRectSize = Vector2.new(100, 100)
			LoadIcon.ImageTransparency = 0.400
			
			Title1.Name = "Title1"
			Title1.Parent = Holder
			Title1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title1.BackgroundTransparency = 1.000
			Title1.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Title1.BorderSizePixel = 0
			Title1.Position = UDim2.new(0, 10, 0, 10)
			Title1.Size = UDim2.new(0, 180, 0, 50)
			Title1.ZIndex = 2
			Title1.Font = Enum.Font.SourceSansBold
			Title1.Text = Window.Name
			Title1.TextSize = 35.000

			Title2.Name = "Title2"
			Title2.Parent = Holder
			Title2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title2.BackgroundTransparency = 1.000
			Title2.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Title2.BorderSizePixel = 0
			Title2.Position = UDim2.new(0, 11, 0, 10)
			Title2.Size = UDim2.new(0, 180, 0, 50)
			Title2.Font = Enum.Font.SourceSansBold
			Title2.Text = Window.Name
			Title2.TextSize = 35.000

			UserIcon.Name = "UserIcon"
			UserIcon.Parent = Holder
			UserIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			UserIcon.BackgroundTransparency = 1.000
			UserIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			UserIcon.BorderSizePixel = 0
			UserIcon.Position = UDim2.new(0, 15, 1, -50)
			UserIcon.Size = UDim2.new(0, 40, 0, 40)
			UserIcon.Image = Options.Icon or Options.icon or "rbxassetid://15011943540"

			IconCorner.CornerRadius = UDim.new(1, 0)
			IconCorner.Name = "IconCorner"
			IconCorner.Parent = UserIcon

			UserName.Name = "UserName"
			UserName.Parent = Holder
			UserName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			UserName.BackgroundTransparency = 1.000
			UserName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			UserName.BorderSizePixel = 0
			UserName.Position = UDim2.new(0, 65, 1, -50)
			UserName.Size = UDim2.new(0, 100, 0, 30)
			UserName.Font = Enum.Font.SourceSans
			UserName.Text = Options.User or Options.user or "portal"
			UserName.TextSize = 14.000
			UserName.TextWrapped = true
			UserName.TextXAlignment = Enum.TextXAlignment.Left
			UserName.TextStrokeTransparency = 1

			Expires.Name = "Expires"
			Expires.Parent = Holder
			Expires.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Expires.BackgroundTransparency = 1.000
			Expires.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Expires.BorderSizePixel = 0
			Expires.Position = UDim2.new(0, 85, 1, -33)
			Expires.Size = UDim2.new(0, 80, 0, 30)
			Expires.Font = Enum.Font.SourceSans
			Expires.Text = Options.Expiry or Options.expiry or "Lifetime"
			Expires.TextSize = 14.000
			Expires.TextWrapped = true
			Expires.TextXAlignment = Enum.TextXAlignment.Left
			Expires.TextStrokeTransparency = 1

			Till.Name = "Till"
			Till.Parent = Holder
			Till.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Till.BackgroundTransparency = 1.000
			Till.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Till.BorderSizePixel = 0
			Till.Position = UDim2.new(0, 65, 1, -33)
			Till.Size = UDim2.new(0, 100, 0, 30)
			Till.Font = Enum.Font.SourceSans
			Till.Text = "Till:"
			Till.TextSize = 14.000
			Till.TextXAlignment = Enum.TextXAlignment.Left
			Till.TextStrokeTransparency = 1

			Tabs.Name = "Tabs"
			Tabs.Parent = Holder
			Tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Tabs.BackgroundTransparency = 1.000
			Tabs.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Tabs.BorderSizePixel = 0
			Tabs.Position = UDim2.new(0, 20, 0, 75)
			Tabs.Size = UDim2.new(0, 160, 0, 370)

			UIListLayout.Parent = Tabs
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 4)
			
			task.spawn(function()
				while wait() do 
					if Library.Typing then
						for i = 1, #Window.Name do
							Title1.Text = string.sub(Window.Name, 1, i) .. "";
							Title2.Text = string.sub(Window.Name, 1, i) .. "";
							wait(0.4);
						end;
					end;
				end;
			end)

			-- Config
			Library:Connection(Save.MouseButton1Down, function()
				writefile("evolution_quicksave.cfg", Library:GetConfig())
				Library:ChangeObjectTheme(Save, "Selected", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
				Library:ChangeObjectTheme(SaveTitle, "Text", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
			end)
			--
			Library:Connection(Save.MouseButton1Up, function()
				Library:ChangeObjectTheme(Save, "Un-Selected", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
				Library:ChangeObjectTheme(SaveTitle, "Dark Text", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
			end)
			--
			Library:Connection(Load.MouseButton1Down, function()
				if isfile("evolution_quicksave.cfg") then
					Library:LoadConfig(readfile("evolution_quicksave.cfg"))
				end
				Library:ChangeObjectTheme(Load, "Selected", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
				Library:ChangeObjectTheme(LoadTitle, "Text", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
			end)
			--
			Library:Connection(Load.MouseButton1Up, function()
				Library:ChangeObjectTheme(Load, "Un-Selected", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
				Library:ChangeObjectTheme(LoadTitle, "Dark Text", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
			end)
			
			function Window:KeyList()
				local NKeyList = {Keybinds = {}};
				--
				local KeyList = Instance.new("Frame")
				local KeyCorner = Instance.new("UICorner")
				local Title = Library:NewInstance("TextLabel", false, "Text")
				local keyboard = Instance.new("ImageButton")
				local Content = Instance.new("Frame")
				local UIListLayout = Instance.new("UIListLayout")
				local space = Instance.new("Frame")
				--
				KeyList.Name = "KeyList"
				KeyList.Parent = EvolutionGUI
				KeyList.AnchorPoint = Vector2.new(0, 0)
				KeyList.BackgroundColor3 = Color3.fromRGB(3, 6, 11)
				KeyList.BackgroundTransparency = 0.2
				KeyList.BorderColor3 = Color3.fromRGB(0, 0, 0)
				KeyList.BorderSizePixel = 0
				KeyList.Position = UDim2.new(0, 5, 0.5, -5)
				KeyList.Size = UDim2.new(0, 180, 0, 0)
				KeyList.Visible = false
				KeyList.AutomaticSize = Enum.AutomaticSize.Y
				
				Library.KeyList = NKeyList;

				KeyCorner.Name = "KeyCorner"
				KeyCorner.Parent = KeyList

				Title.Name = "Title"
				Title.Parent = KeyList
				Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Title.BackgroundTransparency = 1.000
				Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Title.BorderSizePixel = 0
				Title.Position = UDim2.new(0, 40, 0, 2)
				Title.Size = UDim2.new(1, 0, 0, 20)
				Title.Font = Enum.Font.SourceSans
				Title.Text = "Binds"
				Title.TextSize = 14.000
				Title.TextXAlignment = Enum.TextXAlignment.Left

				keyboard.Name = "keyboard"
				keyboard.Parent = KeyList
				keyboard.BackgroundTransparency = 1.000
				keyboard.Position = UDim2.new(0, 8, 0, 0)
				keyboard.Size = UDim2.new(0, 25, 0, 25)
				keyboard.ZIndex = 2
				keyboard.Image = "rbxassetid://3926305904"
				keyboard.ImageRectOffset = Vector2.new(724, 444)
				keyboard.ImageRectSize = Vector2.new(36, 36)

				Content.Name = "Content"
				Content.Parent = KeyList
				Content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Content.BackgroundTransparency = 1.000
				Content.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Content.BorderSizePixel = 0
				Content.Position = UDim2.new(0, 10, 0, 30)
				Content.Size = UDim2.new(1, -20, 1, -40)

				UIListLayout.Parent = Content
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

				space.Name = "space"
				space.Parent = KeyList
				space.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				space.BackgroundTransparency = 1.000
				space.BorderColor3 = Color3.fromRGB(0, 0, 0)
				space.BorderSizePixel = 0
				space.Position = UDim2.new(0, 0, 1, 0)
				space.Size = UDim2.new(1, 0, 0, 5)

				-- Functions
				function NKeyList:SetVisible(State)
					KeyList.Visible = State;
				end;
				--
				function NKeyList:NewKey(Name, Key)
					local KeyValue = {}
					--
					local NewListing = Library:NewInstance("TextLabel", false, "Text")
					--
					NewListing.Name = "NewListing"
					NewListing.Parent = Content
					NewListing.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					NewListing.BackgroundTransparency = 1.000
					NewListing.BorderColor3 = Color3.fromRGB(0, 0, 0)
					NewListing.BorderSizePixel = 0
					NewListing.Size = UDim2.new(1, 0, 0, 20)
					NewListing.Font = Enum.Font.SourceSans
					NewListing.Text = tostring(Name .. " [" .. tostring(Key) .. "]")
					NewListing.TextColor3 = Color3.fromRGB(255, 255, 255)
					NewListing.TextSize = 14.000
					NewListing.TextXAlignment = Enum.TextXAlignment.Left
					NewListing.Visible = false
					--
					function KeyValue:SetVisible(State)
						NewListing.Visible = State;
					end;
					--
					function KeyValue:Update(NewName, NewKey)
						NewListing.Text = tostring(NewName .. " [" .. tostring(NewKey) .. "]")
					end;
					return KeyValue
				end;
				return NKeyList
			end
			Window:KeyList()
			function Window:Watermark()
				local NewWatermark = {Dragging = { false, UDim2.new(0, 0, 0, 0) };};
				--
				local Watermark = Instance.new("TextButton")
				local WaterCorner = Instance.new("UICorner")
				local Title = Instance.new("TextLabel")
				local Title1 = Instance.new("TextLabel")
				local Title2 = Instance.new("TextLabel")
				--
				Watermark.Name = "Watermark"
				Watermark.Parent = Library.ScreenGUI
				Watermark.AnchorPoint = Vector2.new(0.5,0.5)
				Watermark.BackgroundColor3 = Color3.fromRGB(3, 6, 11)
				Watermark.BackgroundTransparency = 0.200
				Watermark.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Watermark.BorderSizePixel = 0
				Watermark.Position = UDim2.new(0, 200, 0, 50)
				Watermark.Size = UDim2.new(0, 0, 0, 20)
				Watermark.AutomaticSize = Enum.AutomaticSize.X
				Watermark.Visible = false
				Watermark.Text = ""
				Watermark.AutoButtonColor = false
				Library.Watermark = NewWatermark

				WaterCorner.CornerRadius = UDim.new(0, 4)
				WaterCorner.Name = "WaterCorner"
				WaterCorner.Parent = Watermark

				Title.Name = "Title"
				Title.Parent = Watermark
				Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Title.BackgroundTransparency = 1.000
				Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Title.BorderSizePixel = 0
				Title.Position = UDim2.new(0, 20, 0, 0)
				Title.Size = UDim2.new(0, 0, 1, 0)
				Title.Font = Enum.Font.SourceSans
				Title.Text = "| placeholder text"
				Title.TextColor3 = Color3.fromRGB(255, 255, 255)
				Title.TextSize = 14.000
				Title.TextXAlignment = Enum.TextXAlignment.Left
				Title.AutomaticSize = Enum.AutomaticSize.X

				Title1.Name = "Title1"
				Title1.Parent = Watermark
				Title1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Title1.BackgroundTransparency = 1.000
				Title1.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Title1.BorderSizePixel = 0
				Title1.Position = UDim2.new(0, 4, 0, 0)
				Title1.Size = UDim2.new(1, 0, 1, 0)
				Title1.ZIndex = 2
				Title1.Font = Enum.Font.SourceSansBold
				Title1.Text = "EV"
				Title1.TextColor3 = Color3.fromRGB(255, 255, 255)
				Title1.TextSize = 14.000
				Title1.TextXAlignment = Enum.TextXAlignment.Left

				Title2.Name = "Title2"
				Title2.Parent = Watermark
				Title2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Title2.BackgroundTransparency = 1.000
				Title2.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Title2.BorderSizePixel = 0
				Title2.Position = UDim2.new(0, 5, 0, 0)
				Title2.Size = UDim2.new(1, 0, 1, 0)
				Title2.Font = Enum.Font.SourceSansBold
				Title2.Text = "EV"
				Title2.TextColor3 = Color3.fromRGB(74, 125, 255)
				Title2.TextSize = 14.000
				Title2.TextXAlignment = Enum.TextXAlignment.Left
				
				-- Functions
				function NewWatermark:SetVisible(State)
					Watermark.Visible = State
				end
				function NewWatermark:UpdateText(txt)
					Title.Text = txt
				end
				
				-- // Dragging
				Library:Connection(Watermark.MouseButton1Down, function()
					local Location = game:GetService("UserInputService"):GetMouseLocation()
					NewWatermark.Dragging[1] = true
					NewWatermark.Dragging[2] = UDim2.new(0, Location.X - Watermark.AbsolutePosition.X, 0, Location.Y - Watermark.AbsolutePosition.Y)
				end)
				Library:Connection(game:GetService("UserInputService").InputEnded, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 and NewWatermark.Dragging[1] then
						local Location = game:GetService("UserInputService"):GetMouseLocation()
						NewWatermark.Dragging[1] = false
						NewWatermark.Dragging[2] = UDim2.new(0, 0, 0, 0)
					end
				end)
				Library:Connection(game:GetService("UserInputService").InputChanged, function(Input)
					local Location = game:GetService("UserInputService"):GetMouseLocation()
					local ActualLocation = nil

					-- Dragging
					if NewWatermark.Dragging[1] then
						TweenService:Create(Watermark, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(
							0,
							Location.X - NewWatermark.Dragging[2].X.Offset + (Watermark.Size.X.Offset * Watermark.AnchorPoint.X),
							0,
							Location.Y - NewWatermark.Dragging[2].Y.Offset + (Watermark.Size.Y.Offset * Watermark.AnchorPoint.Y)
							)}):Play()
					end
				end)
				Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
					if Input.KeyCode == Library.UIKey then
						Library:SetOpen(not Library.Open)
					end
				end)
				
				return NewWatermark
			end
			Window:Watermark()
			-- // Elements
			Window.Elements = {
				TabHolder = Tabs,
				Holder = Holder,
				Inner = Inner,
			}

			-- // Dragging
			Library:Connection(DragButton.MouseButton1Down, function()
				local Location = game:GetService("UserInputService"):GetMouseLocation()
				Window.Dragging[1] = true
				Window.Dragging[2] = UDim2.new(0, Location.X - Holder.AbsolutePosition.X, 0, Location.Y - Holder.AbsolutePosition.Y)
			end)
			Library:Connection(game:GetService("UserInputService").InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 and Window.Dragging[1] then
					local Location = game:GetService("UserInputService"):GetMouseLocation()
					Window.Dragging[1] = false
					Window.Dragging[2] = UDim2.new(0, 0, 0, 0)
				end
			end)
			Library:Connection(game:GetService("UserInputService").InputChanged, function(Input)
				local Location = game:GetService("UserInputService"):GetMouseLocation()
				local ActualLocation = nil

				-- Dragging
				if Window.Dragging[1] then
					TweenService:Create(Holder, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(
						0,
						Location.X - Window.Dragging[2].X.Offset + (Holder.Size.X.Offset * Holder.AnchorPoint.X),
						0,
						Location.Y - Window.Dragging[2].Y.Offset + (Holder.Size.Y.Offset * Holder.AnchorPoint.Y)
					)}):Play()
				end
			end)
			Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
				if Input.KeyCode == Library.UIKey then
					Library:SetOpen(not Library.Open)
				end
			end)

			-- // Functions
			function Window:UpdateTabs()
				for Index, Page in pairs(Window.Pages) do
					Page:Turn(Page.Open)
				end
			end

			-- // Returns
			Library.Holder = Holder
			return setmetatable(Window, Library)
		end;
		--
		function Library:Catagory(Properties)
			local Page = {
				Name = Properties.Name or "Page",
				Window = self,
				Elements = {},
			}
			--
			local Catagory = Library:NewInstance("TextLabel", false, "Dark Text")
			--
			Catagory.Name = "Catagory"
			Catagory.Parent = Page.Window.Elements.TabHolder
			Catagory.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Catagory.BackgroundTransparency = 1.000
			Catagory.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Catagory.BorderSizePixel = 0
			Catagory.Size = UDim2.new(1, 0, 0, 25)
			Catagory.Font = Enum.Font.SourceSans
			Catagory.Text = Page.Name;
			Catagory.TextSize = 15.000
			Catagory.TextXAlignment = Enum.TextXAlignment.Left
		end;
		--
		function Library:Page(Properties)
			if not Properties then
				Properties = {}
			end
			--
			local Page = {
				Name = Properties.Name or "Page",
				Icon = Properties.Icon or Properties.icon or "rbxassetid://14375733866";
				Window = self,
				Open = false,
				Sections = {},
				Elements = {},
			}
			--
			local PageHolder = Instance.new("Frame")
			local NewPage = Library:NewInstance("TextButton", false, "Accent")
			local PageCorner = Instance.new("UICorner")
			local PageName = Library:NewInstance("TextLabel", false, "Text")
			local PageIcon = Library:NewInstance("ImageLabel", false, "Accent")
			local Left = Instance.new("Frame")
			local LeftLayout = Instance.new("UIListLayout")
			local Right = Instance.new("Frame")
			local RightLayout = Instance.new("UIListLayout")
			
			Left.Name = "Left"
			Left.Parent = PageHolder
			Left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Left.BackgroundTransparency = 1.000
			Left.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Left.BorderSizePixel = 0
			Left.Size = UDim2.new(0.485000014, 1, 1, 0)
			Left.ZIndex = 2
			
			LeftLayout.Name = "LeftLayout"
			LeftLayout.Parent = Left
			LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
			LeftLayout.Padding = UDim.new(0, 4)

			Right.Name = "Right"
			Right.Parent = PageHolder
			Right.AnchorPoint = Vector2.new(1, 0)
			Right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Right.BackgroundTransparency = 1.000
			Right.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Right.BorderSizePixel = 0
			Right.Position = UDim2.new(1, 0, 0, 0)
			Right.Size = UDim2.new(0.485000014, 1, 1, 0)

			RightLayout.Name = "RightLayout"
			RightLayout.Parent = Right
			RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
			RightLayout.Padding = UDim.new(0, 4)

			PageHolder.Name = "Page"
			PageHolder.Parent = Page.Window.Elements.Inner
			PageHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			PageHolder.BackgroundTransparency = 1
			PageHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
			PageHolder.BorderSizePixel = 0
			PageHolder.Position = UDim2.new(0, 20, 0, 70)
			PageHolder.Size = UDim2.new(1, -40, 1, -80)
			PageHolder.Visible = false
			PageHolder.ZIndex = 3

			NewPage.Name = "NewPage"
			NewPage.Parent = Page.Window.Elements.TabHolder
			NewPage.BackgroundTransparency = 1
			NewPage.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewPage.BorderSizePixel = 0
			NewPage.Size = UDim2.new(1, 0, 0, 30)
			NewPage.AutoButtonColor = false
			NewPage.Font = Enum.Font.SourceSans
			NewPage.Text = ""
			NewPage.TextColor3 = Color3.fromRGB(0, 0, 0)
			NewPage.TextSize = 14.000

			PageCorner.CornerRadius = UDim.new(0, 4)
			PageCorner.Name = "PageCorner"
			PageCorner.Parent = NewPage

			PageName.Name = "PageName"
			PageName.Parent = NewPage
			PageName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			PageName.BackgroundTransparency = 1.000
			PageName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			PageName.BorderSizePixel = 0
			PageName.Position = UDim2.new(0, 40, 0, 0)
			PageName.Size = UDim2.new(1, -40, 1, 0)
			PageName.Font = Enum.Font.SourceSans
			PageName.Text = Page.Name
			PageName.TextSize = 14.000
			PageName.TextXAlignment = Enum.TextXAlignment.Left
			PageName.TextStrokeTransparency = 1

			PageIcon.Name = "PageIcon"
			PageIcon.Parent = NewPage
			PageIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			PageIcon.BackgroundTransparency = 1.000
			PageIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			PageIcon.BorderSizePixel = 0
			PageIcon.Position = UDim2.new(0, 5, 0, 5)
			PageIcon.Size = UDim2.new(0, 20, 0, 20)
			PageIcon.Image = Page.Icon
			--
			function Page:Turn(bool)
				Page.Open = bool
				TweenService:Create(NewPage, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = Page.Open and 0.95 or 1}):Play()
				PageHolder.Visible = Page.Open
			end
			--
			Library:Connection(NewPage.MouseButton1Down, function()
				if not Page.Open then
					Page:Turn(true)
					for _, Pages in pairs(Page.Window.Pages) do
						if Pages.Open and Pages ~= Page then
							Pages:Turn(false)
						end
					end
				end
			end)

			-- // Elements
			Page.Elements = {
				PageHolder = PageHolder,
				Left = Left,
				Right = Right
			}

			-- // Drawings
			if #Page.Window.Pages == 0 then
				Page:Turn(true)
			end
			Page.Window.Pages[#Page.Window.Pages + 1] = Page
			Page.Window:UpdateTabs()
			return setmetatable(Page, Library.Pages)
		end;
		--
		function Pages:Section(Properties)
			if not Properties then
				Properties = {}
			end
			--
			local Section = {
				Name = Properties.Name or "Section",
				Page = self,
				Side = (Properties.side or Properties.Side or "left"):lower(),
				Size = (Properties.Size or Properties.size or 200),
				ZIndex = Properties.ZIndex or 1, -- Idfk why
				Scrolling = Properties.scroll or Properties.Scroll or false,
				Elements = {},
				Content = {},
			}
			--
			local NewSection = Instance.new("Frame")
			local SectionTitle = Library:NewInstance("TextLabel", false, "Dark Text")
			local SectionHolder = Library:NewInstance("Frame", false, "Dark Accent")
			local SectionCorner = Instance.new("UICorner")
			local Content = Instance.new("ScrollingFrame")
			local ContentLayout = Instance.new("UIListLayout")
			local Stroke1 = Library:NewInstance("UIStroke", false, "Outline")
			--
			Stroke1.Parent = SectionHolder
			Stroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			Stroke1.Thickness = 1
			Stroke1.LineJoinMode = Enum.LineJoinMode.Round

			NewSection.Name = "NewSection"
			NewSection.Parent = Section.Side == "left" and Section.Page.Elements.Left or Section.Side == "right" and Section.Page.Elements.Right
			NewSection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewSection.BackgroundTransparency = 1.000
			NewSection.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewSection.BorderSizePixel = 0
			NewSection.Size = UDim2.new(1,0,0,Section.Size)
			NewSection.ZIndex = Section.ZIndex

			SectionTitle.Name = "SectionTitle"
			SectionTitle.Parent = NewSection
			SectionTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionTitle.BackgroundTransparency = 1.000
			SectionTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionTitle.BorderSizePixel = 0
			SectionTitle.Size = UDim2.new(1, 0, 0, 20)
			SectionTitle.Font = Enum.Font.SourceSans
			SectionTitle.Text = Section.Name
			SectionTitle.TextSize = 14.000
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

			SectionHolder.Name = "SectionHolder"
			SectionHolder.Parent = NewSection
			SectionHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionHolder.BorderSizePixel = 0
			SectionHolder.Position = UDim2.new(0, 0, 0, 25)
			SectionHolder.Size = UDim2.new(1, 0, 1, -25)
			SectionHolder.ClipsDescendants = Section.Scrolling

			SectionCorner.CornerRadius = UDim.new(0, 4)
			SectionCorner.Name = "SectionCorner"
			SectionCorner.Parent = SectionHolder

			Content.Name = "Content"
			Content.Parent = SectionHolder
			Content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Content.BackgroundTransparency = 1.000
			Content.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Content.BorderSizePixel = 0
			Content.Position = UDim2.new(0, 10, 0, 10)
			Content.Size = UDim2.new(1, -20, 1, -20)
			Content.ScrollingEnabled = Section.Scrolling
			Content.CanvasSize = UDim2.new(0,0,1,0)
			Content.ScrollBarImageTransparency = 1
			Content.ClipsDescendants = false
			Content.AutomaticCanvasSize = Enum.AutomaticSize.Y

			ContentLayout.Name = "ContentLayout"
			ContentLayout.Parent = Content
			ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ContentLayout.Padding = UDim.new(0, 8)

			-- // Elements
			Section.Elements = {
				SectionContent = Content;
			}

			-- // Returning
			Section.Page.Sections[#Section.Page.Sections + 1] = Section
			return setmetatable(Section, Library.Sections)
		end
		--
		function Sections:Toggle(Properties)
			if not Properties then
				Properties = {}
			end
			--
			local Toggle = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = Properties.Name or "Toggle",
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or false
				),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
				Toggled = false,
			}
			--
			local NewToggle = Instance.new("TextButton")
			local ToggleTitle = Library:NewInstance("TextLabel", false, "Dark Text")
			local Box = Library:NewInstance("Frame", false, "Un-Selected")
			local BoxCorner = Instance.new("UICorner")
			local Circle = Library:NewInstance("Frame", false, "Circle")
			local BoxCorner_2 = Instance.new("UICorner")
			local Stroke1 = Library:NewInstance("UIStroke", false, "Outline")
			--
			Stroke1.Parent = Box
			Stroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			Stroke1.Thickness = 1
			Stroke1.LineJoinMode = Enum.LineJoinMode.Round

			NewToggle.Name = "NewToggle"
			NewToggle.Parent = Toggle.Section.Elements.SectionContent
			NewToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewToggle.BackgroundTransparency = 1.000
			NewToggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewToggle.BorderSizePixel = 0
			NewToggle.Size = UDim2.new(1, 0, 0, 15)
			NewToggle.AutoButtonColor = false
			NewToggle.Font = Enum.Font.SourceSans
			NewToggle.Text = ""
			NewToggle.TextColor3 = Color3.fromRGB(0, 0, 0)
			NewToggle.TextSize = 14.000

			ToggleTitle.Name = "ToggleTitle"
			ToggleTitle.Parent = NewToggle
			ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleTitle.BackgroundTransparency = 1.000
			ToggleTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleTitle.BorderSizePixel = 0
			ToggleTitle.Size = UDim2.new(1, -50, 1, 0)
			ToggleTitle.Font = Enum.Font.SourceSans
			ToggleTitle.Text = Toggle.Name
			ToggleTitle.TextSize = 14.000
			ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

			Box.Name = "Box"
			Box.Parent = NewToggle
			Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Box.BorderSizePixel = 0
			Box.Position = UDim2.new(1, -35, 0, 0)
			Box.Size = UDim2.new(0, 35, 1, 0)

			BoxCorner.CornerRadius = UDim.new(1, 0)
			BoxCorner.Name = "BoxCorner"
			BoxCorner.Parent = Box

			Circle.Name = "Circle"
			Circle.Parent = Box
			Circle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Circle.BorderSizePixel = 0
			Circle.Size = UDim2.new(0, 15, 1, 0)

			BoxCorner_2.CornerRadius = UDim.new(1, 0)
			BoxCorner_2.Name = "BoxCorner"
			BoxCorner_2.Parent = Circle
			

			-- // Functions
			local function SetState()
				Toggle.Toggled = not Toggle.Toggled
				if Toggle.Toggled then
					Library:ChangeObjectTheme(Circle, "Accent", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
					Library:ChangeObjectTheme(Box, "Selected", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
					Library:ChangeObjectTheme(ToggleTitle, "Text", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
					TweenService:Create(Circle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1,-15,0,0)}):Play()
				else
					Library:ChangeObjectTheme(Circle, "Circle", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
					Library:ChangeObjectTheme(Box, "Un-Selected", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
					Library:ChangeObjectTheme(ToggleTitle, "Dark Text", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
					TweenService:Create(Circle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0)}):Play()
				end
				Library.Flags[Toggle.Flag] = Toggle.Toggled
				Toggle.Callback(Toggle.Toggled)
			end
			--
			Library:Connection(NewToggle.MouseButton1Down, SetState)

			-- // Misc Functions
			function Toggle.Set(bool)
				bool = type(bool) == "boolean" and bool or false
				if Toggle.Toggled ~= bool then
					SetState()
				end
			end
			Toggle.Set(Toggle.State)
			Library.Flags[Toggle.Flag] = Toggle.State
			Flags[Toggle.Flag] = Toggle.Set

			-- // Returning
			return Toggle
		end
		--
		function Sections:Slider(Properties)
			if not Properties then
				Properties = {}
			end
			--
			local Slider = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = Properties.Name or nil,
				Min = (Properties.min or Properties.Min or Properties.minimum or Properties.Minimum or 0),
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or 10
				),
				Max = (Properties.max or Properties.Max or Properties.maximum or Properties.Maximum or 100),
				Sub = (
					Properties.suffix
						or Properties.Suffix
						or Properties.ending
						or Properties.Ending
						or Properties.prefix
						or Properties.Prefix
						or Properties.measurement
						or Properties.Measurement
						or ""
				),
				Decimals = (Properties.decimals or Properties.Decimals or 1),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				)
			}
			local TextValue = ("[value]" .. Slider.Sub)
			--
			local NewSlider = Instance.new("Frame")
			local ToggleTitle = Library:NewInstance("TextLabel", false, "Dark Text")
			local Slide = Library:NewInstance("Frame", false, "Outline")
			local SlideAccent = Library:NewInstance("Frame", false, "Accent")
			local SlideCorner = Instance.new("UICorner")
			local AccentCorner = Instance.new("UICorner")
			local Circle = Library:NewInstance("TextButton", false, "Accent")
			local CircleCorner = Instance.new("UICorner")
			local Drag = Instance.new("TextButton")
			local Box = Library:NewInstance("Frame", false, "Un-Selected")
			local BoxCorner = Instance.new("UICorner")
			local ToggleTitle_2 = Library:NewInstance("TextLabel", false, "Dark Text")
			local Stroke1 = Library:NewInstance("UIStroke", false, "Outline")
			--
			Stroke1.Parent = Box
			Stroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			Stroke1.Thickness = 1
			Stroke1.LineJoinMode = Enum.LineJoinMode.Round

			NewSlider.Name = "NewSlider"
			NewSlider.Parent = Slider.Section.Elements.SectionContent
			NewSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewSlider.BackgroundTransparency = 1.000
			NewSlider.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewSlider.BorderSizePixel = 0
			NewSlider.Size = UDim2.new(1, 0, 0, 18)

			ToggleTitle.Name = "ToggleTitle"
			ToggleTitle.Parent = NewSlider
			ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleTitle.BackgroundTransparency = 1.000
			ToggleTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleTitle.BorderSizePixel = 0
			ToggleTitle.Size = UDim2.new(1, -50, 1, 0)
			ToggleTitle.Font = Enum.Font.SourceSans
			ToggleTitle.Text = Slider.Name
			ToggleTitle.TextSize = 14.000
			ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

			Slide.Name = "Slide"
			Slide.Parent = NewSlider
			Slide.AnchorPoint = Vector2.new(0, 0.5)
			Slide.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Slide.BorderSizePixel = 0
			Slide.Position = UDim2.new(1, -110, 0.5, 0)
			Slide.Size = UDim2.new(0, 75, 0, 4)

			SlideCorner.CornerRadius = UDim.new(1, 0)
			SlideCorner.Name = "SlideCorner"
			SlideCorner.Parent = Slide
			
			SlideAccent.Name = "Slide"
			SlideAccent.Parent = Slide
			SlideAccent.AnchorPoint = Vector2.new(0, 0)
			SlideAccent.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SlideAccent.BorderSizePixel = 0
			SlideAccent.Position = UDim2.new(0,0,0,0)
			SlideAccent.Size = UDim2.new(0,0,1,0)

			AccentCorner.CornerRadius = UDim.new(1, 0)
			AccentCorner.Name = "SlideCorner"
			AccentCorner.Parent = SlideAccent

			Circle.Name = "Circle"
			Circle.Parent = SlideAccent
			Circle.AnchorPoint = Vector2.new(0, 0.5)
			Circle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Circle.BorderSizePixel = 0
			Circle.Position = UDim2.new(1, -6, 0.5, 0)
			Circle.Size = UDim2.new(0, 12, 0, 12)
			Circle.AutoButtonColor = false
			Circle.Text = ""

			CircleCorner.CornerRadius = UDim.new(1, 0)
			CircleCorner.Name = "CircleCorner"
			CircleCorner.Parent = Circle

			Drag.Name = "Drag"
			Drag.Parent = Slide
			Drag.AnchorPoint = Vector2.new(0, 0.5)
			Drag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Drag.BackgroundTransparency = 1.000
			Drag.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Drag.BorderSizePixel = 0
			Drag.Position = UDim2.new(0, 0, 0.5, 0)
			Drag.Size = UDim2.new(1, 0, 0, 16)
			Drag.AutoButtonColor = false
			Drag.Font = Enum.Font.SourceSans
			Drag.Text = ""
			Drag.TextColor3 = Color3.fromRGB(0, 0, 0)
			Drag.TextSize = 14.000

			Box.Name = "Box"
			Box.Parent = NewSlider
			Box.AnchorPoint = Vector2.new(0, 0.5)
			Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Box.BorderSizePixel = 0
			Box.Position = UDim2.new(1, -25, 0.5, 0)
			Box.Size = UDim2.new(0, 25, 1, -5)

			BoxCorner.CornerRadius = UDim.new(0, 4)
			BoxCorner.Name = "BoxCorner"
			BoxCorner.Parent = Box

			ToggleTitle_2.Name = "ToggleTitle"
			ToggleTitle_2.Parent = Box
			ToggleTitle_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleTitle_2.BackgroundTransparency = 1.000
			ToggleTitle_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleTitle_2.BorderSizePixel = 0
			ToggleTitle_2.Size = UDim2.new(1, 0, 1, 0)
			ToggleTitle_2.Font = Enum.Font.SourceSans
			ToggleTitle_2.Text = "100%"
			ToggleTitle_2.TextSize = 14.000
			ToggleTitle_2.TextWrapped = true

			-- // Functions
			local Sliding = false
			local Val = Slider.State
			local function Set(value)
				value = math.clamp(Library:Round(value, Slider.Decimals), Slider.Min, Slider.Max)

				local sizeX = ((value - Slider.Min) / (Slider.Max - Slider.Min))
				TweenService:Create(SlideAccent, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(sizeX, 0, 1, 0)}):Play()
				ToggleTitle_2.Text = TextValue:gsub("%[value%]", string.format("%.14g", value))
				Val = value

				Library.Flags[Slider.Flag] = value
				Slider.Callback(value)
			end				
			--
			local function SlideInp(input)
				local sizeX = (input.Position.X - Slide.AbsolutePosition.X) / Slide.AbsoluteSize.X
				local value = ((Slider.Max - Slider.Min) * sizeX) + Slider.Min
				Set(value)
			end
			--
			Library:Connection(Drag.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = true
					SlideInp(input)
				end
			end)
			Library:Connection(Drag.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = false
				end
			end)
			Library:Connection(Circle.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = true
					SlideInp(input)
				end
			end)
			Library:Connection(Circle.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Sliding = false
				end
			end)
			Library:Connection(game:GetService("UserInputService").InputChanged, function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					if Sliding then
						SlideInp(input)
					end
				end
			end)
			Library:Connection(Box.MouseEnter, function()
				ToggleTitle_2.TextWrapped = false
			end)
			Library:Connection(Box.MouseLeave, function()
				ToggleTitle_2.TextWrapped = true
			end)
			--
			function Slider:Set(Value)
				Set(Value)
			end
			--
			Flags[Slider.Flag] = Set
			Library.Flags[Slider.Flag] = Slider.State
			Set(Slider.State)

			-- // Returning
			return Slider
		end
		--
		function Sections:List(Properties)
			local Properties = Properties or {};
			local Dropdown = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Open = false,
				Name = Properties.Name or Properties.name or nil,
				Options = (Properties.options or Properties.Options or Properties.values or Properties.Values or {
					"1",
					"2",
					"3",
				}),
				Max = (Properties.Max or Properties.max or nil),
				ScrollMax = (Properties.ScrollingMax or Properties.scrollingmax or nil),
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or nil
				),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
				OptionInsts = {},
			}
			--
			local NewList = Instance.new("TextButton")
			local ToggleTitle = Library:NewInstance("TextLabel", false, "Dark Text")
			local Box = Library:NewInstance("Frame", false, "Un-Selected")
			local BoxCorner = Instance.new("UICorner")
			local Value = Library:NewInstance("TextLabel", false, "Dark Text")
			local Arrow = Instance.new("TextLabel")
			local List = Library:NewInstance("ScrollingFrame", false, "Un-Selected")
			local ListCorner = Instance.new("UICorner")
			local UIListLayout = Instance.new("UIListLayout")
			local Stroke1 = Library:NewInstance("UIStroke", false, "Outline")
			--
			Stroke1.Parent = Box
			Stroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			Stroke1.Thickness = 1
			Stroke1.LineJoinMode = Enum.LineJoinMode.Round

			NewList.Name = "NewList"
			NewList.Parent = Dropdown.Section.Elements.SectionContent
			NewList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewList.BackgroundTransparency = 1.000
			NewList.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewList.BorderSizePixel = 0
			NewList.Size = UDim2.new(1, 0, 0, 18)
			NewList.ZIndex = 1
			NewList.AutoButtonColor = false
			NewList.Font = Enum.Font.SourceSans
			NewList.Text = ""
			NewList.TextColor3 = Color3.fromRGB(0, 0, 0)
			NewList.TextSize = 14.000

			ToggleTitle.Name = "ToggleTitle"
			ToggleTitle.Parent = NewList
			ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleTitle.BackgroundTransparency = 1.000
			ToggleTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleTitle.BorderSizePixel = 0
			ToggleTitle.Size = UDim2.new(1, -50, 1, 0)
			ToggleTitle.Font = Enum.Font.SourceSans
			ToggleTitle.Text = Dropdown.Name
			ToggleTitle.TextSize = 14.000
			ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

			Box.Name = "Box"
			Box.Parent = NewList
			Box.AnchorPoint = Vector2.new(0, 0.5)
			Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Box.BorderSizePixel = 0
			Box.Position = UDim2.new(1, -104, 0.5, 0)
			Box.Size = UDim2.new(0, 104, 1, 0)

			BoxCorner.CornerRadius = UDim.new(0, 4)
			BoxCorner.Name = "BoxCorner"
			BoxCorner.Parent = Box

			Value.Name = "Value"
			Value.Parent = Box
			Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Value.BackgroundTransparency = 1.000
			Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Value.BorderSizePixel = 0
			Value.Position = UDim2.new(0, 5, 0, 0)
			Value.Size = UDim2.new(1, -25, 1, 0)
			Value.Font = Enum.Font.SourceSans
			Value.Text = ""
			Value.TextSize = 14.000
			Value.TextWrapped = true
			Value.TextXAlignment = Enum.TextXAlignment.Left

			Arrow.Name = "Arrow"
			Arrow.Parent = Box
			Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Arrow.BackgroundTransparency = 1.000
			Arrow.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Arrow.BorderSizePixel = 0
			Arrow.Position = UDim2.new(0, -8, 0, -2)
			Arrow.Size = UDim2.new(1, 0, 1, 0)
			Arrow.Font = Enum.Font.SourceSans
			Arrow.Text = "v"
			Arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
			Arrow.TextSize = 14.000
			Arrow.TextWrapped = true
			Arrow.TextXAlignment = Enum.TextXAlignment.Right

			List.Name = "List"
			List.Parent = Library.ScreenGUI
			List.BorderColor3 = Color3.fromRGB(0, 0, 0)
			List.BorderSizePixel = 0
			List.AnchorPoint = Vector2.new(0,0.5)
			List.Position = UDim2.new(0, Box.AbsolutePosition.X, 0, Box.AbsolutePosition.Y)
			List.Size = UDim2.new(0, Box.AbsoluteSize.X, 0, 0)
			List.Visible = false
			List.ScrollingEnabled = true
			List.ScrollBarImageTransparency = 0
			List.AutomaticCanvasSize = Enum.AutomaticSize.Y
			List.CanvasSize = UDim2.new(0,0,0,0)
			List.ScrollBarThickness = 2
			List.ZIndex = 100

			ListCorner.CornerRadius = UDim.new(0,4)
			ListCorner.Name = "ListCorner"
			ListCorner.Parent = List

			UIListLayout.Parent = List
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

			-- // Connections
			Library:Connection(NewList.MouseButton1Down, function()
				List.Visible = true
				NewList.ZIndex = 3
				List.Position = UDim2.new(0, Box.AbsolutePosition.X, 0, Box.AbsolutePosition.Y)
			end)
			Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
				if List.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not Library:IsMouseOverFrame(List) and not Library:IsMouseOverFrame(Box) then
						List.Visible = false
						NewList.ZIndex = 1
					end
				end
			end)
			--
			local chosen = Dropdown.Max and {} or nil
			local Count = 0
			--
			local function handleoptionclick(option, button, text)
				button.MouseButton1Down:Connect(function()
					if Dropdown.Max then
						if table.find(chosen, option) then
							table.remove(chosen, table.find(chosen, option))

							local textchosen = {}
							local cutobject = false

							for _, opt in next, chosen do
								table.insert(textchosen, opt)
							end

							Value.Text = #chosen == 0 and "" or table.concat(textchosen, ",") .. (cutobject and ", ..." or "")

							Library:ChangeObjectTheme(text, "Dark Text")

							Library.Flags[Dropdown.Flag] = chosen
							Dropdown.Callback(chosen)
						else
							if #chosen == Dropdown.Max then
								Library:ChangeObjectTheme(Dropdown.OptionInsts[chosen[1]].text, "Dark Text")
								table.remove(chosen, 1)
							end

							table.insert(chosen, option)

							local textchosen = {}
							local cutobject = false

							for _, opt in next, chosen do
								table.insert(textchosen, opt)
							end

							Value.Text = #chosen == 0 and "" or table.concat(textchosen, ",") .. (cutobject and ", ..." or "")

							Library:ChangeObjectTheme(text, "Text")

							Library.Flags[Dropdown.Flag] = chosen
							Dropdown.Callback(chosen)
						end
					else
						for opt, tbl in next, Dropdown.OptionInsts do
							if opt ~= option then
								Library:ChangeObjectTheme(tbl.text, "Dark Text")
							end
						end
						chosen = option
						Value.Text = option
						Library:ChangeObjectTheme(text, "Text")
						List.Visible = false
						NewList.ZIndex = 1
						Library.Flags[Dropdown.Flag] = option
						Dropdown.Callback(option)
					end
				end)
			end
			--
			local function createoptions(tbl)
				for _, option in next, tbl do
					Dropdown.OptionInsts[option] = {}
					local NewOption = Instance.new("TextButton")
					local OptionTitle = Library:NewInstance("TextLabel", false, "Dark Text")
					NewOption.Name = "NewOption"
					NewOption.Parent = List
					NewOption.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					NewOption.BackgroundTransparency = 1.000
					NewOption.BorderColor3 = Color3.fromRGB(0, 0, 0)
					NewOption.BorderSizePixel = 0
					NewOption.Size = UDim2.new(1, 0, 0, 20)
					NewOption.AutoButtonColor = false
					NewOption.Font = Enum.Font.SourceSans
					NewOption.Text = ""
					NewOption.TextColor3 = Color3.fromRGB(0, 0, 0)
					NewOption.TextSize = 14.000
					Dropdown.OptionInsts[option].button = NewOption
					--
					OptionTitle.Name = "OptionTitle"
					OptionTitle.Parent = NewOption
					OptionTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					OptionTitle.BackgroundTransparency = 1.000
					OptionTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
					OptionTitle.BorderSizePixel = 0
					OptionTitle.Position = UDim2.new(0, 8, 0, 0)
					OptionTitle.Size = UDim2.new(1, 0, 1, 0)
					OptionTitle.Font = Enum.Font.SourceSans
					OptionTitle.Text = option
					OptionTitle.TextSize = 14.000
					OptionTitle.TextXAlignment = Enum.TextXAlignment.Left
					Dropdown.OptionInsts[option].text = OptionTitle
					
					Count = Count + 1

					if Dropdown.ScrollMax then
						List.AutomaticSize = Enum.AutomaticSize.None
						if Count < Dropdown.ScrollMax then
						else
							List.Size = UDim2.new(0, Box.AbsoluteSize.X, 0, 20*Dropdown.ScrollMax)
						end
					else
						List.AutomaticSize = Enum.AutomaticSize.Y
					end
					handleoptionclick(option, NewOption, OptionTitle)
				end
			end
			createoptions(Dropdown.Options)
			--
			local set
			set = function(option)
				if Dropdown.Max then
					table.clear(chosen)
					option = type(option) == "table" and option or {}

					for opt, tbl in next, Dropdown.OptionInsts do
						if not table.find(option, opt) then
							Library:ChangeObjectTheme(tbl.text, "Dark Text")
						end
					end

					for i, opt in next, option do
						if table.find(Dropdown.Options, opt) and #chosen < Dropdown.Max then
							table.insert(chosen, opt)
							Library:ChangeObjectTheme(Dropdown.OptionInsts[opt].text, "Dark Text")
						end
					end

					local textchosen = {}
					local cutobject = false

					for _, opt in next, chosen do
						table.insert(textchosen, opt)
					end

					Value.Text = #chosen == 0 and "" or table.concat(textchosen, ",") .. (cutobject and ", ..." or "")

					Library.Flags[Dropdown.Flag] = chosen
					Dropdown.Callback(chosen)
				end
			end
			--
			function Dropdown:Set(option)
				if Dropdown.Max then
					set(option)
				else
					for opt, tbl in next, Dropdown.OptionInsts do
						if opt ~= option then
							Library:ChangeObjectTheme(tbl.text, "Dark Text")
						end
					end
					if table.find(Dropdown.Options, option) then
						chosen = option
						Value.Text = option
						Library:ChangeObjectTheme(Dropdown.OptionInsts[option].text, "Text")
						Library.Flags[Dropdown.Flag] = chosen
						Dropdown.Callback(chosen)
					else
						chosen = nil
						Value.Text = ""
						Library.Flags[Dropdown.Flag] = chosen
						Dropdown.Callback(chosen)
					end
				end
			end
			--
			function Dropdown:Refresh(tbl)
				for _, opt in next, Dropdown.OptionInsts do
					coroutine.wrap(function()
						table.remove(Library.ThemeObjects.Objects, table.find(Library.ThemeObjects.Objects, opt.text))
						opt.button:Destroy()
					end)()
				end
				table.clear(Dropdown.OptionInsts)

				createoptions(tbl)

				if Dropdown.Max then
					table.clear(chosen)
				else
					chosen = nil
				end

				Library.Flags[Dropdown.Flag] = chosen
				Dropdown.Callback(chosen)
			end

			-- // Returning
			if Dropdown.Max then
				Flags[Dropdown.Flag] = set
			else
				Flags[Dropdown.Flag] = Dropdown
			end
			Dropdown:Set(Dropdown.State)
			return Dropdown
		end
		--
		function Sections:Keybind(Properties)
			local Properties = Properties or {}
			local Keybind = {
				Section = self,
				Name = Properties.name or Properties.Name or "Keybind",
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or Enum.KeyCode.E
				),
				Mode = (Properties.mode or Properties.Mode or "Toggle"),
				UseKey = (Properties.UseKey or false),
				Ignore = (Properties.ignore or Properties.Ignore or false),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
				Binding = nil,
			}
			local Key
			local State = false
			--
			local NewBind = Instance.new("Frame")
			local ToggleTitle = Library:NewInstance("TextLabel", false, "Dark Text")
			local Box = Library:NewInstance("TextButton", false, "Un-Selected")
			local BoxCorner = Instance.new("UICorner")
			local Value = Library:NewInstance("TextLabel", false, "Dark Text")
			local ModeBox = Library:NewInstance("Frame", false, "Un-Selected")
			local ModeCorner = Instance.new("UICorner")
			local HoldText = Library:NewInstance("TextLabel", false, Keybind.Mode == 'Hold' and "Text" or "Dark Text")
			local ToggleText = Library:NewInstance("TextLabel", false, Keybind.Mode == 'Toggle' and "Text" or "Dark Text")
			local AlwaysText = Library:NewInstance("TextLabel", false, Keybind.Mode == 'Always' and "Text" or "Dark Text")
			local Hold = Instance.new("TextButton")
			local Toggle = Instance.new("TextButton")
			local Always = Instance.new("TextButton")
			local Stroke1 = Library:NewInstance("UIStroke", false, "Outline")
			local Stroke2 = Library:NewInstance("UIStroke", false, "Outline")
			local ListValue = Library.KeyList:NewKey(Keybind.Name, Keybind.State)
			--
			Stroke1.Parent = Box
			Stroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			Stroke1.Thickness = 1
			Stroke1.LineJoinMode = Enum.LineJoinMode.Round
			
			Stroke2.Parent = ModeBox
			Stroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			Stroke2.Thickness = 1
			Stroke2.LineJoinMode = Enum.LineJoinMode.Round

			NewBind.Name = "NewBind"
			NewBind.Parent = Keybind.Section.Elements.SectionContent
			NewBind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewBind.BackgroundTransparency = 1.000
			NewBind.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewBind.BorderSizePixel = 0
			NewBind.Size = UDim2.new(1, 0, 0, 18)

			ToggleTitle.Name = "ToggleTitle"
			ToggleTitle.Parent = NewBind
			ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleTitle.BackgroundTransparency = 1.000
			ToggleTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleTitle.BorderSizePixel = 0
			ToggleTitle.Size = UDim2.new(1, -50, 1, 0)
			ToggleTitle.Font = Enum.Font.SourceSans
			ToggleTitle.Text = Keybind.Name
			ToggleTitle.TextSize = 14.000
			ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

			Box.Name = "Box"
			Box.Parent = NewBind
			Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Box.BorderSizePixel = 0
			Box.Position = UDim2.new(1, -40, 0, 0)
			Box.Size = UDim2.new(0, 40, 1, 0)
			Box.AutoButtonColor = false
			Box.Text = ""

			BoxCorner.CornerRadius = UDim.new(0, 4)
			BoxCorner.Name = "BoxCorner"
			BoxCorner.Parent = Box

			Value.Name = "Value"
			Value.Parent = Box
			Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Value.BackgroundTransparency = 1.000
			Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Value.BorderSizePixel = 0
			Value.Size = UDim2.new(1, 0, 1, 0)
			Value.Font = Enum.Font.SourceSans
			Value.Text = "MB2"
			Value.TextSize = 14.000
			Value.TextWrapped = true

			ModeBox.Name = "ModeBox"
			ModeBox.Parent = Box
			ModeBox.AnchorPoint = Vector2.new(0, 0.5)
			ModeBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ModeBox.BorderSizePixel = 0
			ModeBox.Position = UDim2.new(1, 5, 0.5, 0)
			ModeBox.Size = UDim2.new(0, 40, 1, 40)
			ModeBox.Visible = false

			ModeCorner.CornerRadius = UDim.new(0, 4)
			ModeCorner.Name = "ModeCorner"
			ModeCorner.Parent = ModeBox

			HoldText.Name = "HoldText"
			HoldText.Parent = ModeBox
			HoldText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HoldText.BackgroundTransparency = 1.000
			HoldText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			HoldText.BorderSizePixel = 0
			HoldText.Size = UDim2.new(1, 0, 0.333000004, 0)
			HoldText.Font = Enum.Font.SourceSans
			HoldText.Text = "Hold"
			HoldText.TextSize = 14.000
			HoldText.TextWrapped = true

			ToggleText.Name = "ToggleText"
			ToggleText.Parent = ModeBox
			ToggleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleText.BackgroundTransparency = 1.000
			ToggleText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleText.BorderSizePixel = 0
			ToggleText.Position = UDim2.new(0, 0, 0.333000004, 0)
			ToggleText.Size = UDim2.new(1, 0, 0.333000004, 0)
			ToggleText.Font = Enum.Font.SourceSans
			ToggleText.Text = "Toggle"
			ToggleText.TextSize = 14.000
			ToggleText.TextWrapped = true

			AlwaysText.Name = "AlwaysText"
			AlwaysText.Parent = ModeBox
			AlwaysText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			AlwaysText.BackgroundTransparency = 1.000
			AlwaysText.BorderColor3 = Color3.fromRGB(0, 0, 0)
			AlwaysText.BorderSizePixel = 0
			AlwaysText.Position = UDim2.new(0, 0, 0.666999996, 0)
			AlwaysText.Size = UDim2.new(1, 0, 0.333000004, 0)
			AlwaysText.Font = Enum.Font.SourceSans
			AlwaysText.Text = "Always"
			AlwaysText.TextSize = 14.000
			AlwaysText.TextWrapped = true

			Hold.Name = "Hold"
			Hold.Parent = ModeBox
			Hold.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Hold.BackgroundTransparency = 1.000
			Hold.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Hold.BorderSizePixel = 0
			Hold.Size = UDim2.new(1, 0, 0.333000004, 0)
			Hold.AutoButtonColor = false
			Hold.Font = Enum.Font.SourceSans
			Hold.Text = ""
			Hold.TextColor3 = Color3.fromRGB(0, 0, 0)
			Hold.TextSize = 14.000

			Toggle.Name = "Toggle"
			Toggle.Parent = ModeBox
			Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Toggle.BackgroundTransparency = 1.000
			Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Toggle.BorderSizePixel = 0
			Toggle.Position = UDim2.new(0, 0, 0.333000004, 0)
			Toggle.Size = UDim2.new(1, 0, 0.333000004, 0)
			Toggle.AutoButtonColor = false
			Toggle.Font = Enum.Font.SourceSans
			Toggle.Text = ""
			Toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
			Toggle.TextSize = 14.000

			Always.Name = "Always"
			Always.Parent = ModeBox
			Always.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Always.BackgroundTransparency = 1.000
			Always.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Always.BorderSizePixel = 0
			Always.Position = UDim2.new(0, 0, 0.666999996, 0)
			Always.Size = UDim2.new(1, 0, 0.333000004, 0)
			Always.AutoButtonColor = false
			Always.Font = Enum.Font.SourceSans
			Always.Text = ""
			Always.TextColor3 = Color3.fromRGB(0, 0, 0)
			Always.TextSize = 14.000

			-- // Functions
			local function set(newkey)
				if string.find(tostring(newkey), "Enum") then
					if c then
						c:Disconnect()
						if Keybind.Flag then
							Library.Flags[Keybind.Flag] = false
						end
						Keybind.Callback(false)
					end
					if tostring(newkey):find("Enum.KeyCode.") then
						newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
					elseif tostring(newkey):find("Enum.UserInputType.") then
						newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
					end
					if newkey == Enum.KeyCode.Backspace then
						Key = nil
						if Keybind.UseKey then
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = Key
							end
							Keybind.Callback(Key)
						end
						local text = "None"

						Value.Text = text
						ListValue:Update(Keybind.Name, text)
					elseif newkey ~= nil then
						Key = newkey
						if Keybind.UseKey then
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = Key
							end
							Keybind.Callback(Key)
						end
						local text = (Library.Keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))

						Value.Text = text
						ListValue:Update(Keybind.Name, text)
					end

					Library.Flags[Keybind.Flag .. "_KEY"] = newkey
				elseif table.find({ "Always", "Toggle", "Hold" }, newkey) then
					if not Keybind.UseKey then
						Library.Flags[Keybind.Flag .. "_KEY STATE"] = newkey
						Keybind.Mode = newkey
						ListValue:Update(Keybind.Name, (Library.Keys[Key] or tostring(Key):gsub("Enum.KeyCode.", "")))
						if Keybind.Mode == "Always" then
							State = true
							if Keybind.Flag then
								Library.Flags[Keybind.Flag] = State
							end
							Keybind.Callback(true)
							ListValue:SetVisible(true)
						end
					end
				else
					State = newkey
					if Keybind.Flag then
						Library.Flags[Keybind.Flag] = newkey
					end
					Keybind.Callback(newkey)
				end
			end
			--
			set(Keybind.State)
			set(Keybind.Mode)
			Box.MouseButton1Click:Connect(function()
				if not Keybind.Binding then

					Value.Text = "..."

					Keybind.Binding = Library:Connection(
						game:GetService("UserInputService").InputBegan,
						function(input, gpe)
							set(
								input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode
									or input.UserInputType
							)
							Library:Disconnect(Keybind.Binding)
							task.wait()
							Keybind.Binding = nil
						end
					)
				end
			end)
			--
			Library:Connection(game:GetService("UserInputService").InputBegan, function(inp)
				if (inp.KeyCode == Key or inp.UserInputType == Key) and not Keybind.Binding and not Keybind.UseKey then
					if Keybind.Mode == "Hold" then
						if Keybind.Flag then
							Library.Flags[Keybind.Flag] = true
						end
						c = Library:Connection(game:GetService("RunService").RenderStepped, function()
							if Keybind.Callback then
								Keybind.Callback(true)
							end
						end)
						ListValue:SetVisible(true)
					elseif Keybind.Mode == "Toggle" then
						State = not State
						if Keybind.Flag then
							Library.Flags[Keybind.Flag] = State
						end
						Keybind.Callback(State)
						ListValue:SetVisible(State)
					end
				end
			end)
			--
			Library:Connection(game:GetService("UserInputService").InputEnded, function(inp)
				if Keybind.Mode == "Hold" and not Keybind.UseKey then
					if Key ~= "" or Key ~= nil then
						if inp.KeyCode == Key or inp.UserInputType == Key then
							if c then
								c:Disconnect()
								if Keybind.Flag then
									Library.Flags[Keybind.Flag] = false
								end
								if Keybind.Callback then
									Keybind.Callback(false)
								end
								ListValue:SetVisible(false)
							end
						end
					end
				end
			end)
			Library:Connection(Box.MouseButton2Down, function()
				ModeBox.Visible = true
			end)
			--
			Library:Connection(Hold.MouseButton1Down, function()
				set("Hold")
				Library:ChangeObjectTheme(HoldText, "Text")
				Library:ChangeObjectTheme(ToggleText, "Dark Text")
				Library:ChangeObjectTheme(AlwaysText, "Dark Text")
				ModeBox.Visible = false
			end)
			--
			Library:Connection(Toggle.MouseButton1Down, function()
				set("Toggle")
				Library:ChangeObjectTheme(HoldText, "Dark Text")
				Library:ChangeObjectTheme(ToggleText, "Text")
				Library:ChangeObjectTheme(AlwaysText, "Dark Text")
				ModeBox.Visible = false
			end)
			--
			Library:Connection(Always.MouseButton1Down, function()
				set("Always")
				Library:ChangeObjectTheme(HoldText, "Dark Text")
				Library:ChangeObjectTheme(ToggleText, "Dark Text")
				Library:ChangeObjectTheme(AlwaysText, "Text")
				ModeBox.Visible = false
			end)
			--
			Library:Connection(game:GetService("UserInputService").InputBegan, function(Input)
				if ModeBox.Visible and Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not Library:IsMouseOverFrame(ModeBox) then
						ModeBox.Visible = false
					end
				end
			end)
			--
			Library.Flags[Keybind.Flag .. "_KEY"] = Keybind.State
			Library.Flags[Keybind.Flag .. "_KEY STATE"] = Keybind.Mode
			Flags[Keybind.Flag] = set
			Flags[Keybind.Flag .. "_KEY"] = set
			Flags[Keybind.Flag .. "_KEY STATE"] = set
			--
			function Keybind:Set(key)
				set(key)
			end

			-- // Returning
			return Keybind
		end
		--
		function Sections:Colorpicker(Properties)
			local Properties = Properties or {}
			local Colorpicker = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = (Properties.Name or "Colorpicker"),
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or Color3.fromRGB(255, 0, 0)
				),
				Alpha = (
					Properties.alpha
						or Properties.Alpha
						or Properties.transparency
						or Properties.Transparency
						or 1
				),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
				Colorpickers = 0,
			}
			--
			local NewColor = Instance.new("TextButton")
			local ToggleTitle = Library:NewInstance("TextLabel", false, "Dark Text")
			--
			NewColor.Name = "NewColor"
			NewColor.Parent = Colorpicker.Section.Elements.SectionContent
			NewColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewColor.BackgroundTransparency = 1.000
			NewColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewColor.BorderSizePixel = 0
			NewColor.Size = UDim2.new(1, 0, 0, 18)
			NewColor.ZIndex = 3
			NewColor.AutoButtonColor = false
			NewColor.Font = Enum.Font.SourceSans
			NewColor.Text = ""
			NewColor.TextColor3 = Color3.fromRGB(0, 0, 0)
			NewColor.TextSize = 14.000

			ToggleTitle.Name = "ToggleTitle"
			ToggleTitle.Parent = NewColor
			ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleTitle.BackgroundTransparency = 1.000
			ToggleTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleTitle.BorderSizePixel = 0
			ToggleTitle.Size = UDim2.new(1, -50, 1, 0)
			ToggleTitle.Font = Enum.Font.SourceSans
			ToggleTitle.Text = Colorpicker.Name
			ToggleTitle.TextSize = 14.000
			ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

			-- // Functions
			Colorpicker.Colorpickers = Colorpicker.Colorpickers + 1
			local colorpickertypes = Library:NewPicker(
				Colorpicker.Name,
				Colorpicker.State,
				Colorpicker.Alpha,
				NewColor,
				Colorpicker.Colorpickers,
				Colorpicker.Flag,
				Colorpicker.Callback
			)

			function Colorpicker:Set(color)
				colorpickertypes:Set(color, false, true)
			end
			
			function Colorpicker:Colorpicker(Properties)
				local Properties = Properties or {}
				local NewColorpicker = {
					State = (
						Properties.state
							or Properties.State
							or Properties.def
							or Properties.Def
							or Properties.default
							or Properties.Default
							or Color3.fromRGB(255, 0, 0)
					),
					Alpha = (
						Properties.alpha
							or Properties.Alpha
							or Properties.transparency
							or Properties.Transparency
							or 1
					),
					Callback = (
						Properties.callback
							or Properties.Callback
							or Properties.callBack
							or Properties.CallBack
							or function() end
					),
					Flag = (
						Properties.flag
							or Properties.Flag
							or Properties.pointer
							or Properties.Pointer
							or Library.NextFlag()
					),
				}
				-- // Functions
				Colorpicker.Colorpickers = Colorpicker.Colorpickers + 1
				local Newcolorpickertypes = Library:NewPicker(
					"",
					NewColorpicker.State,
					NewColorpicker.Alpha,
					NewColor,
					Colorpicker.Colorpickers,
					NewColorpicker.Flag,
					NewColorpicker.Callback
				)

				function NewColorpicker:Set(color)
					Newcolorpickertypes:Set(color)
				end

				-- // Returning
				return NewColorpicker
			end

			-- // Returning
			return Colorpicker
		end
		--
		function Sections:Textbox(Properties)
			local Properties = Properties or {}
			local Textbox = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = (Properties.Name or Properties.name or "textbox"),
				Placeholder = (
					Properties.placeholder
						or Properties.Placeholder
						or Properties.holder
						or Properties.Holder
						or ""
				),
				State = (
					Properties.state
						or Properties.State
						or Properties.def
						or Properties.Def
						or Properties.default
						or Properties.Default
						or ""
				),
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
				Flag = (
					Properties.flag
						or Properties.Flag
						or Properties.pointer
						or Properties.Pointer
						or Library.NextFlag()
				),
			}
			--
			local NewInput = Instance.new("TextButton")
			local ToggleTitle = Library:NewInstance("TextLabel", false, "Dark Text")
			local Box = Library:NewInstance("Frame", false, "Un-Selected")
			local BoxCorner = Instance.new("UICorner")
			local Value = Library:NewInstance("TextBox", false, "Text")
			local Stroke1 = Library:NewInstance("UIStroke", false, "Outline")
			--
			Stroke1.Parent = Box
			Stroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			Stroke1.Thickness = 1
			Stroke1.LineJoinMode = Enum.LineJoinMode.Round
			
			NewInput.Name = "NewInput"
			NewInput.Parent = Textbox.Section.Elements.SectionContent
			NewInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewInput.BackgroundTransparency = 1.000
			NewInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewInput.BorderSizePixel = 0
			NewInput.Size = UDim2.new(1, 0, 0, 18)
			NewInput.AutoButtonColor = false
			NewInput.Font = Enum.Font.SourceSans
			NewInput.Text = ""
			NewInput.TextColor3 = Color3.fromRGB(0, 0, 0)
			NewInput.TextSize = 14.000

			ToggleTitle.Name = "ToggleTitle"
			ToggleTitle.Parent = NewInput
			ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleTitle.BackgroundTransparency = 1.000
			ToggleTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleTitle.BorderSizePixel = 0
			ToggleTitle.Size = UDim2.new(1, -50, 1, 0)
			ToggleTitle.Font = Enum.Font.SourceSans
			ToggleTitle.Text = Textbox.Name
			ToggleTitle.TextSize = 14.000
			ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

			Box.Name = "Box"
			Box.Parent = NewInput
			Box.AnchorPoint = Vector2.new(0, 0.5)
			Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Box.BorderSizePixel = 0
			Box.Position = UDim2.new(1, -104, 0.5, 0)
			Box.Size = UDim2.new(0, 104, 1, 0)

			BoxCorner.CornerRadius = UDim.new(0, 4)
			BoxCorner.Name = "BoxCorner"
			BoxCorner.Parent = Box

			Value.Name = "Value"
			Value.Parent = Box
			Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Value.BackgroundTransparency = 1.000
			Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Value.BorderSizePixel = 0
			Value.Position = UDim2.new(0, 4, 0, 0)
			Value.Size = UDim2.new(1, -8, 1, 0)
			Value.Font = Enum.Font.SourceSans
			Value.Text = Textbox.State
			Value.ClearTextOnFocus = false
			Value.TextSize = 14.000
			Value.TextWrapped = true
			Value.TextXAlignment = Enum.TextXAlignment.Left
			--
			Value.Focused:Connect(function()
				Library:ChangeObjectTheme(Box, "Selected", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
			end)
			Value.FocusLost:Connect(function()
				Textbox.Callback(Value.Text)
				Library.Flags[Textbox.Flag] = Value.Text
				Library:ChangeObjectTheme(Box, "Un-Selected", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
			end)
			--
			local function set(str)
				Value.Text = str
				Library.Flags[Textbox.Flag] = str
				Textbox.Callback(str)
			end

			-- // Return
			Flags[Textbox.Flag] = set
			return Textbox
		end
		--
		function Sections:Button(Properties)
			local Properties = Properties or {}
			local Button = {
				Window = self.Window,
				Page = self.Page,
				Section = self,
				Name = Properties.Name or "button",
				Callback = (
					Properties.callback
						or Properties.Callback
						or Properties.callBack
						or Properties.CallBack
						or function() end
				),
			}
			--
			local NewButton = Instance.new("TextButton")
			local Box = Library:NewInstance("Frame", false, "Un-Selected")
			local BoxCorner = Instance.new("UICorner")
			local Value = Library:NewInstance("TextLabel", false, "Dark Text")
			local Stroke1 = Library:NewInstance("UIStroke", false, "Outline")
			--
			Stroke1.Parent = Box
			Stroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			Stroke1.Thickness = 1
			Stroke1.LineJoinMode = Enum.LineJoinMode.Round

			NewButton.Name = "NewButton"
			NewButton.Parent = Button.Section.Elements.SectionContent
			NewButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			NewButton.BackgroundTransparency = 1.000
			NewButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NewButton.BorderSizePixel = 0
			NewButton.Size = UDim2.new(1, 0, 0, 18)
			NewButton.AutoButtonColor = false
			NewButton.Font = Enum.Font.SourceSans
			NewButton.Text = ""
			NewButton.TextColor3 = Color3.fromRGB(0, 0, 0)
			NewButton.TextSize = 14.000

			Box.Name = "Box"
			Box.Parent = NewButton
			Box.AnchorPoint = Vector2.new(0, 0.5)
			Box.BackgroundColor3 = Color3.fromRGB(8, 9, 17)
			Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Box.BorderSizePixel = 0
			Box.Position = UDim2.new(0, 0, 0.5, 0)
			Box.Size = UDim2.new(1, 0, 1, 0)

			BoxCorner.CornerRadius = UDim.new(0, 4)
			BoxCorner.Name = "BoxCorner"
			BoxCorner.Parent = Box

			Value.Name = "Value"
			Value.Parent = Box
			Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Value.BackgroundTransparency = 1.000
			Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Value.BorderSizePixel = 0
			Value.Size = UDim2.new(1, 0, 1, 0)
			Value.Font = Enum.Font.SourceSans
			Value.Text = Button.Name
			Value.TextColor3 = Color3.fromRGB(121, 122, 126)
			Value.TextSize = 14.000
			Value.TextWrapped = true
			--
			Library:Connection(NewButton.MouseButton1Down, function()
				Button.Callback()
				Library:ChangeObjectTheme(Box, "Selected", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
				Library:ChangeObjectTheme(Value, "Text", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
			end)
			--
			Library:Connection(NewButton.MouseButton1Up, function()
				Library:ChangeObjectTheme(Box, "Un-Selected", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
				Library:ChangeObjectTheme(Value, "Dark Text", true, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
			end)
		end
		--
	end;

end;

-- Local Variables
local Flags = Library.Flags
local Pointers = Library.Pointers
local Utility = Library.Utility

getfenv(0)["Library"] = Library;
getfenv(0)["Flags"] = Flags;
getfenv(0)["Pointers"] = Pointers;

-- // Example
do
    local Example = Library:Window({User = game.Players.LocalPlayer.DisplayName,Icon = game:GetService("Players"):GetUserThumbnailAsync(game.Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)})
    Library.Watermark:UpdateText("| Vision. (Premium)")
    Example:Catagory({Name = "Aimbot"})
    local Tab1 = Example:Page({Name = "Ragebot"})
    Example:Page({Name = "Anti-Aim", Icon = "rbxassetid://14436167187"})
    Example:Page({Name = "Legitbot", Icon = "rbxassetid://16081386298"})
    Example:Catagory({Name = "Visuals"})
    Example:Page({Name = "Players", Icon = "rbxassetid://16149111731"})
    Example:Page({Name = "World", Icon = "rbxassetid://10507357657"})
    Example:Catagory({Name = "Hood customs blatant"})
    --
    local Section = Tab1:Section({Name = "Main", Size = 180})
    local Sec2 = Tab1:Section({Name = "Section", Size = 200})
    local Sec3 = Tab1:Section({Name = "Other", Side = "Right", Size = 200, Scroll = true})
    --
    Section:Toggle({Name = "Checkbox"})
    Section:Toggle({Name = "Hello World"})
    Section:Toggle({Name = "Lorem ipsum dolor"})
    Section:Slider({Name = "Slider", Suffix = "%"})
    Section:Toggle({Name = "Key List", Flag = "KeyList", Callback = function(s) Library.KeyList:SetVisible(s) end})
    Section:Toggle({Name = "Watermark", Flag = "Watermark", Callback = function(s) Library.Watermark:SetVisible(s) end})
    --
    Sec2:List({Name = "Scroll Combo",Options = {"green fn", "fent", "shit", "fort", "nite"}, ScrollingMax = 3})
    Sec2:List({Name = "Combo",Options = {"green fn", "fent", "shit", "fort", "nite"}})
    Sec2:List({Name = "Multi Combo",Options = {"green fn", "fent", "shit", "fort", "nite"}, Max = 3, ScrollingMax = 3})
    Sec2:Keybind({Name = "Key Pick", Default = Enum.UserInputType.MouseButton2})
    local a = Sec2:Colorpicker({Name = "Color", Flag = "test", Callback = function(s) end})
    a:Colorpicker({})
    Sec2:Textbox({Name = "Input"})
    --
    local ThemePickers = {}
    Sec3:List({Name = "Theme", Flag = "SelectedTheme", Options = {"Default","Red","Purple"}})
    Sec3:Button({Name = "Load Theme", Callback = function() 
        Library:LoadTheme(Library.Flags["SelectedTheme"])
        for Option,Picker in next, ThemePickers do
            Picker:Set(Library.Theme[Option])
        end;
    end})
    ThemePickers["Accent"] = Sec3:Colorpicker({Name = "Accent", Flag = "LibraryAccent", Default = Library.Theme["Accent"], Callback = function(s) Library:ChangeThemeColor("Accent", s) end})
    ThemePickers["Dark Accent"] = Sec3:Colorpicker({Name = "Dark Accent", Flag = "LibraryDarkAccent", Default = Library.Theme["Dark Accent"], Callback = function(s) Library:ChangeThemeColor("Dark Accent", s) end})
    ThemePickers["Text"] = Sec3:Colorpicker({Name = "Text", Flag = "LibraryText", Default = Library.Theme["Text"], Callback = function(s) Library:ChangeThemeColor("Text", s) end})
    ThemePickers["Dark Text"] = Sec3:Colorpicker({Name = "Dark Text", Flag = "LibraryDarkText", Default = Library.Theme["Dark Text"], Callback = function(s) Library:ChangeThemeColor("Dark Text", s) end})
    ThemePickers["Holder"] = Sec3:Colorpicker({Name = "Holder", Flag = "LibraryHolder", Default = Library.Theme["Holder"], Callback = function(s) Library:ChangeThemeColor("Holder", s) end})
    ThemePickers["Top"] = Sec3:Colorpicker({Name = "Top", Flag = "LibraryTop", Default = Library.Theme["Top"], Callback = function(s) Library:ChangeThemeColor("Top", s) end})
    ThemePickers["Un-Selected"] = Sec3:Colorpicker({Name = "Un-Selected", Flag = "LibraryUnSelected", Default = Library.Theme["Un-Selected"], Callback = function(s) Library:ChangeThemeColor("Un-Selected", s) end})
    ThemePickers["Selected"] = Sec3:Colorpicker({Name = "Selected", Flag = "LibrarySelected", Default = Library.Theme["Selected"], Callback = function(s) Library:ChangeThemeColor("Selected", s) end})
    ThemePickers["Outline"] = Sec3:Colorpicker({Name = "Outline", Flag = "LibraryOutline", Default = Library.Theme["Outline"], Callback = function(s) Library:ChangeThemeColor("Outline", s) end})
    Sec3:Toggle({Name = "Typing Effect", Flag = "Typing", Callback = function(s) Library.Typing = s end})
end

return Library;
