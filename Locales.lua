-- QuickChannels localization.
-- UI strings follow the game client language (GetLocale()); missing keys fall back to English.
-- Channel names themselves come from the game's own localized globals (SAY, PARTY, ...).
-- Corrections from native speakers are welcome.

local _, ns = ...

local LOCALES = {}

LOCALES.enUS = {
  ui = {
    leftClick   = "Left-click: talk in this channel",
    rightClick  = "Right-click: menu",
    drag        = "Drag to move",
    altDrag     = "Alt + drag to move",
    hide        = "Hide this button",
    hiddenList  = "Restore hidden button",
    showAll     = "Show all",
    lock        = "Lock bar",
    vertical    = "Vertical bar",
    fade        = "Fade when not hovered",
    background  = "Bar background",
    onlyAvail   = "Only available channels",
    keepText    = "Keep typed text",
    latin       = "Use English letters",
    reset       = "Reset settings and position",
    reply       = "Reply",
    unavailable = "Not available right now",
    help        = "commands: lock, unlock, vertical, horizontal, scale <0.5-2>, size <16-40>, fade, bg, avail, latin, showall, reset",
  },
  labels = {
    SAY = "S", YELL = "Y", EMOTE = "E", PARTY = "P", INSTANCE = "I", RAID = "R",
    RAID_WARNING = "RW", GUILD = "G", OFFICER = "O", WHISPER = "W", REPLY = "Re",
  },
}

LOCALES.ruRU = {
  ui = {
    leftClick   = "ЛКМ — писать в этот канал",
    rightClick  = "ПКМ — меню",
    drag        = "Перетащите, чтобы переместить",
    altDrag     = "Alt + перетаскивание — переместить",
    hide        = "Скрыть эту кнопку",
    hiddenList  = "Вернуть скрытую кнопку",
    showAll     = "Показать все",
    lock        = "Закрепить панель",
    vertical    = "Вертикальная панель",
    fade        = "Прятать без наведения",
    background  = "Фон панели",
    onlyAvail   = "Только доступные каналы",
    keepText    = "Сохранять набранный текст",
    latin       = "Английские буквы на кнопках",
    reset       = "Сбросить настройки и позицию",
    reply       = "Ответить",
    unavailable = "Сейчас недоступно",
    help        = "команды: lock, unlock, vertical, horizontal, scale <0.5-2>, size <16-40>, fade, bg, avail, latin, showall, reset",
  },
  labels = {
    SAY = "С", YELL = "К", EMOTE = "Э", PARTY = "Гр", INSTANCE = "П", RAID = "Р",
    RAID_WARNING = "ОР", GUILD = "Г", OFFICER = "О", WHISPER = "Ш", REPLY = "От",
  },
}

LOCALES.deDE = {
  ui = {
    leftClick   = "Linksklick: in diesem Kanal schreiben",
    rightClick  = "Rechtsklick: Menü",
    drag        = "Ziehen zum Verschieben",
    altDrag     = "Alt + Ziehen zum Verschieben",
    hide        = "Diese Schaltfläche ausblenden",
    hiddenList  = "Ausgeblendete wiederherstellen",
    showAll     = "Alle anzeigen",
    lock        = "Leiste sperren",
    vertical    = "Vertikale Leiste",
    fade        = "Ausblenden ohne Mauszeiger",
    background  = "Leistenhintergrund",
    onlyAvail   = "Nur verfügbare Kanäle",
    keepText    = "Getippten Text behalten",
    latin       = "Englische Buchstaben",
    reset       = "Einstellungen und Position zurücksetzen",
    reply       = "Antworten",
    unavailable = "Derzeit nicht verfügbar",
    help        = "Befehle: lock, unlock, vertical, horizontal, scale <0.5-2>, size <16-40>, fade, bg, avail, latin, showall, reset",
  },
  labels = {
    SAY = "S", YELL = "Sc", EMOTE = "E", PARTY = "G", INSTANCE = "I", RAID = "SZ",
    RAID_WARNING = "SW", GUILD = "Gi", OFFICER = "O", WHISPER = "F", REPLY = "A",
  },
}

LOCALES.frFR = {
  ui = {
    leftClick   = "Clic gauche : parler dans ce canal",
    rightClick  = "Clic droit : menu",
    drag        = "Glisser pour déplacer",
    altDrag     = "Alt + glisser pour déplacer",
    hide        = "Masquer ce bouton",
    hiddenList  = "Restaurer un bouton masqué",
    showAll     = "Tout afficher",
    lock        = "Verrouiller la barre",
    vertical    = "Barre verticale",
    fade        = "Estomper hors survol",
    background  = "Fond de la barre",
    onlyAvail   = "Canaux disponibles uniquement",
    keepText    = "Conserver le texte saisi",
    latin       = "Lettres anglaises",
    reset       = "Réinitialiser réglages et position",
    reply       = "Répondre",
    unavailable = "Indisponible pour le moment",
    help        = "commandes : lock, unlock, vertical, horizontal, scale <0.5-2>, size <16-40>, fade, bg, avail, latin, showall, reset",
  },
  labels = {
    SAY = "D", YELL = "C", EMOTE = "E", PARTY = "G", INSTANCE = "I", RAID = "R",
    RAID_WARNING = "AR", GUILD = "Gu", OFFICER = "O", WHISPER = "Ch", REPLY = "Ré",
  },
}

LOCALES.esES = {
  ui = {
    leftClick   = "Clic izquierdo: hablar en este canal",
    rightClick  = "Clic derecho: menú",
    drag        = "Arrastra para mover",
    altDrag     = "Alt + arrastrar para mover",
    hide        = "Ocultar este botón",
    hiddenList  = "Restaurar botón oculto",
    showAll     = "Mostrar todos",
    lock        = "Bloquear barra",
    vertical    = "Barra vertical",
    fade        = "Atenuar sin el ratón encima",
    background  = "Fondo de la barra",
    onlyAvail   = "Solo canales disponibles",
    keepText    = "Conservar el texto escrito",
    latin       = "Letras en inglés",
    reset       = "Restablecer ajustes y posición",
    reply       = "Responder",
    unavailable = "No disponible ahora",
    help        = "comandos: lock, unlock, vertical, horizontal, scale <0.5-2>, size <16-40>, fade, bg, avail, latin, showall, reset",
  },
  labels = {
    SAY = "D", YELL = "G", EMOTE = "E", PARTY = "Gr", INSTANCE = "I", RAID = "B",
    RAID_WARNING = "AB", GUILD = "H", OFFICER = "O", WHISPER = "S", REPLY = "R",
  },
}
LOCALES.esMX = LOCALES.esES

LOCALES.itIT = {
  ui = {
    leftClick   = "Clic sinistro: scrivi in questo canale",
    rightClick  = "Clic destro: menu",
    drag        = "Trascina per spostare",
    altDrag     = "Alt + trascina per spostare",
    hide        = "Nascondi questo pulsante",
    hiddenList  = "Ripristina pulsante nascosto",
    showAll     = "Mostra tutti",
    lock        = "Blocca barra",
    vertical    = "Barra verticale",
    fade        = "Sfuma senza mouse sopra",
    background  = "Sfondo della barra",
    onlyAvail   = "Solo canali disponibili",
    keepText    = "Mantieni il testo scritto",
    latin       = "Lettere inglesi",
    reset       = "Ripristina impostazioni e posizione",
    reply       = "Rispondi",
    unavailable = "Non disponibile ora",
    help        = "comandi: lock, unlock, vertical, horizontal, scale <0.5-2>, size <16-40>, fade, bg, avail, latin, showall, reset",
  },
  labels = {
    SAY = "D", YELL = "U", EMOTE = "E", PARTY = "Gr", INSTANCE = "I", RAID = "In",
    RAID_WARNING = "AI", GUILD = "G", OFFICER = "Uf", WHISPER = "S", REPLY = "R",
  },
}

LOCALES.ptBR = {
  ui = {
    leftClick   = "Clique esquerdo: falar neste canal",
    rightClick  = "Clique direito: menu",
    drag        = "Arraste para mover",
    altDrag     = "Alt + arrastar para mover",
    hide        = "Ocultar este botão",
    hiddenList  = "Restaurar botão oculto",
    showAll     = "Mostrar todos",
    lock        = "Travar barra",
    vertical    = "Barra vertical",
    fade        = "Esmaecer sem o mouse",
    background  = "Fundo da barra",
    onlyAvail   = "Somente canais disponíveis",
    keepText    = "Manter o texto digitado",
    latin       = "Letras em inglês",
    reset       = "Redefinir configurações e posição",
    reply       = "Responder",
    unavailable = "Indisponível no momento",
    help        = "comandos: lock, unlock, vertical, horizontal, scale <0.5-2>, size <16-40>, fade, bg, avail, latin, showall, reset",
  },
  labels = {
    SAY = "D", YELL = "G", EMOTE = "E", PARTY = "Gr", INSTANCE = "I", RAID = "R",
    RAID_WARNING = "AR", GUILD = "Gu", OFFICER = "O", WHISPER = "S", REPLY = "Re",
  },
}

LOCALES.koKR = {
  ui = {
    leftClick   = "왼쪽 클릭: 이 채널로 대화",
    rightClick  = "오른쪽 클릭: 메뉴",
    drag        = "드래그하여 이동",
    altDrag     = "Alt + 드래그하여 이동",
    hide        = "이 버튼 숨기기",
    hiddenList  = "숨긴 버튼 복원",
    showAll     = "모두 표시",
    lock        = "바 잠금",
    vertical    = "세로 바",
    fade        = "마우스가 없으면 흐리게",
    background  = "바 배경",
    onlyAvail   = "사용 가능한 채널만",
    keepText    = "입력한 텍스트 유지",
    latin       = "영문 글자 사용",
    reset       = "설정 및 위치 초기화",
    reply       = "답장",
    unavailable = "현재 사용할 수 없음",
    help        = "명령어: lock, unlock, vertical, horizontal, scale <0.5-2>, size <16-40>, fade, bg, avail, latin, showall, reset",
  },
  labels = {
    SAY = "말", YELL = "외", EMOTE = "감", PARTY = "파", INSTANCE = "인", RAID = "공",
    RAID_WARNING = "경", GUILD = "길", OFFICER = "관", WHISPER = "귓", REPLY = "답",
  },
}

LOCALES.zhCN = {
  ui = {
    leftClick   = "左键：在此频道发言",
    rightClick  = "右键：菜单",
    drag        = "拖动以移动",
    altDrag     = "Alt + 拖动以移动",
    hide        = "隐藏此按钮",
    hiddenList  = "恢复隐藏的按钮",
    showAll     = "全部显示",
    lock        = "锁定条",
    vertical    = "竖排",
    fade        = "鼠标移开时淡出",
    background  = "背景",
    onlyAvail   = "仅显示可用频道",
    keepText    = "保留已输入的文字",
    latin       = "使用英文字母",
    reset       = "重置设置和位置",
    reply       = "回复",
    unavailable = "当前不可用",
    help        = "命令：lock, unlock, vertical, horizontal, scale <0.5-2>, size <16-40>, fade, bg, avail, latin, showall, reset",
  },
  labels = {
    SAY = "说", YELL = "喊", EMOTE = "表", PARTY = "队", INSTANCE = "副", RAID = "团",
    RAID_WARNING = "警", GUILD = "会", OFFICER = "官", WHISPER = "密", REPLY = "回",
  },
}

LOCALES.zhTW = {
  ui = {
    leftClick   = "左鍵：在此頻道發言",
    rightClick  = "右鍵：選單",
    drag        = "拖曳以移動",
    altDrag     = "Alt + 拖曳以移動",
    hide        = "隱藏此按鈕",
    hiddenList  = "恢復隱藏的按鈕",
    showAll     = "全部顯示",
    lock        = "鎖定列",
    vertical    = "直排",
    fade        = "滑鼠移開時淡出",
    background  = "背景",
    onlyAvail   = "僅顯示可用頻道",
    keepText    = "保留已輸入的文字",
    latin       = "使用英文字母",
    reset       = "重置設定和位置",
    reply       = "回覆",
    unavailable = "目前無法使用",
    help        = "指令：lock, unlock, vertical, horizontal, scale <0.5-2>, size <16-40>, fade, bg, avail, latin, showall, reset",
  },
  labels = {
    SAY = "說", YELL = "喊", EMOTE = "表", PARTY = "隊", INSTANCE = "副", RAID = "團",
    RAID_WARNING = "警", GUILD = "會", OFFICER = "官", WHISPER = "密", REPLY = "回",
  },
}

local en = LOCALES.enUS
local cur = LOCALES[GetLocale()] or en

if cur ~= en then
  setmetatable(cur.ui, { __index = en.ui })
  setmetatable(cur.labels, { __index = en.labels })
end
ns.L = cur.ui
ns.LabelsLocal = cur.labels
ns.LabelsLatin = en.labels
