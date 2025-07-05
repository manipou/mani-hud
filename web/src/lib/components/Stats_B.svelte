<script lang="ts">
	import { tweened } from 'svelte/motion';
	import { cubicOut } from 'svelte/easing';
	import { Hud } from '$lib/stores/VisibilityStore';
	import { onDestroy } from 'svelte';
	
	// Create tweened values for smooth transitions
	const money = tweened(0, {
		duration: 600,
		easing: cubicOut
	});
	
	const bank = tweened(0, {
		duration: 600,
		easing: cubicOut
	});
	
	const blackMoney = tweened(0, {
		duration: 600,
		easing: cubicOut
	});

	$: {
		if ($Hud.PlayerData) {
			money.set($Hud.PlayerData.Money);
			bank.set($Hud.PlayerData.Bank);
			blackMoney.set($Hud.PlayerData.BlackMoney);
		}
	}

	// Format currency with flexible options
	function formatCurrency(value: number): string {
		// Format with thousands separator
		const formattedValue = value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, $Hud.Currency.Separator);
		
		// Position the currency symbol correctly
		if ($Hud.Currency.Position === "before") {
			return `${$Hud.Currency.Symbol}${formattedValue}`;
		} else {
			return `${formattedValue}${$Hud.Currency.Symbol}`;
		}
	}
	
	// Initialize current time and date
	let currentTime = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: false });
	let currentDate = new Date().toLocaleDateString([], { month: '2-digit', day: '2-digit' });
	
	// Update time using a timer variable
	let timer = 0;
	
	// Update timer every minute
	const timerInterval = setInterval(() => {
		// Update the timer to trigger reactivity
		timer += 1;
		
		// Update time and date
		const now = new Date();
		currentTime = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: false });
		currentDate = now.toLocaleDateString([], { month: '2-digit', day: '2-digit' });
	}, 60000);
	
	// Clean up interval when component is destroyed
	onDestroy(() => {
		clearInterval(timerInterval);
	});
</script>

<svelte:head>
	<link href="https://fonts.googleapis.com/css2?family=Share+Tech&family=Roboto+Mono:wght@400;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</svelte:head>

<!-- Modern and clean Stats container with styling to match the blue theme -->
<div class="fixed top-[1.5vh] right-[1.5vh] flex flex-col items-end gap-[1vh] pointer-events-none">
     
    <!-- Stats panel with modern layout and blue theme -->
    <div class="w-[20vh] rounded-md overflow-hidden border border-blue-500/30 shadow-lg shadow-blue-900/30">
        <!-- Compact header with single row layout -->
        <div class="bg-blue-950/90 px-[1.2vh] py-[0.8vh] flex justify-between items-center">
            <!-- Left side: ID -->
            <div class="flex items-center gap-[0.8vh]">
                <div class="w-[2vh] flex justify-center">
                    <i class="fas fa-id-card text-blue-300 text-[1.3vh]"></i>
                </div>
                <span class="text-blue-300 text-[1.3vh]">{$Hud?.Id ?? '---'}</span>
            </div>
            
            <!-- Center: Date and time -->
            <div class="flex items-center">
                <span class="text-blue-300 text-[1.3vh]">{currentDate} {currentTime}</span>
            </div>
            
            <!-- Right side: player count and logo -->
            <div class="flex items-center gap-[1.2vh]">
                <!-- Player count with pulse indicator -->
                {#if $Hud.PlayerCount}
                    <div class="flex items-center gap-[0.5vh]">
                        <div class="w-[0.5vh] h-[0.5vh] rounded-full bg-green-400 animate-pulse"></div>
                        <span class="text-blue-300 text-[1.3vh]">{$Hud.PlayerCount}</span>
                    </div>
                {/if}
            </div>
        </div>
        
        <!-- Separator line -->
        <div class="h-[1px] bg-gradient-to-r from-blue-500/10 via-blue-400/30 to-blue-500/10"></div>
        
        <!-- Main stats section with improved readability -->
        <div class="bg-blue-950/80 p-[1.2vh] space-y-[1.4vh]">
            <!-- Cash with icon -->
            <div class="flex justify-between items-center">
                <div class="flex items-center gap-[0.8vh]">
                    <div class="w-[2vh] flex justify-center">
                        <i class="fas fa-wallet text-blue-300/90 text-[1.3vh]"></i>
                    </div>
                    <span class="text-blue-300/90 text-[1.1vh] uppercase tracking-wide">Kontanter</span>
                </div>
                <span class="text-blue-300 text-[1.3vh] font-bold tracking-wide drop-shadow-[0_0_1px_rgba(0,100,255,0.7)]">
                    {formatCurrency(Math.floor($money))}
                </span>
            </div>
            
            <!-- Bank with icon -->
            <div class="flex justify-between items-center">
                <div class="flex items-center gap-[0.8vh]">
                    <div class="w-[2vh] flex justify-center">
                        <i class="fas fa-landmark text-blue-300/90 text-[1.3vh]"></i>
                    </div>
                    <span class="text-blue-300/90 text-[1.1vh] uppercase tracking-wide">Bank</span>
                </div>
                <span class="text-blue-300 text-[1.3vh] font-bold tracking-wide drop-shadow-[0_0_1px_rgba(0,100,255,0.7)]">
                    {formatCurrency(Math.floor($bank))}
                </span>
            </div>
            
            <!-- Black Money with icon (only show if has some) -->
            {#if $blackMoney > 0}
                <div class="flex justify-between items-center">
                    <div class="flex items-center gap-[0.8vh]">
                        <div class="w-[2vh] flex justify-center">
                            <i class="fas fa-coins text-red-300/90 text-[1.3vh]"></i>
                        </div>
                        <span class="text-red-300/90 text-[1.1vh] uppercase tracking-wide">Sorte</span>
                    </div>
                    <span class="text-red-300 text-[1.3vh] font-bold tracking-wide drop-shadow-[0_0_1px_rgba(255,0,0,0.7)]">
                        {formatCurrency(Math.floor($blackMoney))}
                    </span>
                </div>
            {/if}
            
            <!-- Job info -->
            <div class="flex justify-between items-center">
                <div class="flex items-center gap-[0.8vh]">
                    <div class="w-[2vh] flex justify-center">
                        <i class="fas fa-briefcase text-blue-300/90 text-[1.3vh]"></i>
                    </div>
                    <span class="text-blue-300/90 text-[1.1vh] uppercase tracking-wide">Job</span>
                </div>
                <div class="text-right">
                    <span class="text-blue-300 text-[1.3vh] font-bold tracking-wide drop-shadow-[0_0_1px_rgba(0,100,255,0.7)]">
                        {$Hud.PlayerData.Job}
                    </span>
                    {#if $Hud.PlayerData.Grade}
                        <div class="text-blue-300/80 text-[1vh]">{$Hud.PlayerData.Grade}</div>
                    {/if}
                </div>
            </div>
        </div>
    </div>
</div>