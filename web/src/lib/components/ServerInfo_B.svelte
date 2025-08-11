<script lang="ts">
	import { onDestroy } from 'svelte';
	import { Hud } from '$lib/stores/VisibilityStore';

	// Date and time
	let currentDate = '';
	let currentTime = '';
	
	// Update date and time every minute
	function updateDateTime() {
		const now = new Date();
		
		// Format date as DD.MM.YYYY
		const day = now.getDate().toString().padStart(2, '0');
		const month = (now.getMonth() + 1).toString().padStart(2, '0');
		const year = now.getFullYear();
		currentDate = `${day}.${month}.${year}`;
		
		// Format time as HH:MM (24-hour format)
		const hours = now.getHours().toString().padStart(2, '0');
		const minutes = now.getMinutes().toString().padStart(2, '0');
		currentTime = `${hours}:${minutes}`;
	}
	
	// Update time immediately and then every minute
	updateDateTime();
	const interval = setInterval(updateDateTime, 60000);
	
	// Clean up interval on component destruction
	onDestroy(() => {
		clearInterval(interval);
	});
</script>

<svelte:head>
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</svelte:head>

<!-- Server Info Container -->
<div class="flex flex-col items-end pointer-events-none font-['Inter'] select-none">
	<!-- Server Logo -->
	{#if $Hud.ServerLogo}
		<div class="mb-[1vh]">
			<img 
				src={$Hud.ServerLogo} 
				alt="Server Logo" 
				class="h-[4vh] w-auto object-contain drop-shadow-lg"
			/>
		</div>
	{/if}
	
	<!-- Player ID -->
	<div class="flex items-center gap-[0.6vh] mb-[0.5vh] flex-row-reverse">
		<i class="fas fa-user text-emerald-400 text-[1.2vh] drop-shadow-md"></i>
		<span class="text-emerald-300 text-[1.2vh] font-medium font-['JetBrains_Mono'] drop-shadow-md">
			#{$Hud.Id}
		</span>
		<span class="text-white text-[1.2vh] font-medium drop-shadow-md">ID: </span>
	</div>
	
	<!-- Player Count -->
	<div class="flex items-center gap-[0.6vh] mb-[0.5vh] flex-row-reverse">
		<i class="fas fa-users text-blue-400 text-[1.2vh] drop-shadow-md"></i>
		<span class="text-blue-300 text-[1.2vh] font-medium font-['JetBrains_Mono'] drop-shadow-md">
			{$Hud.PlayerCount}
		</span>
		<span class="text-white text-[1.2vh] font-medium drop-shadow-md">Online: </span>
	</div>

    <!-- Date & Time Combined -->
	<div class="flex items-center gap-[0.6vh] flex-row-reverse">
		<i class="fas fa-clock text-cyan-400 text-[1.2vh] drop-shadow-md"></i>
		<div class="flex flex-col items-end">
			<span class="text-cyan-300 text-[1.2vh] font-medium font-['JetBrains_Mono'] drop-shadow-md leading-tight">
				{currentTime}
			</span>
			<span class="text-cyan-300/80 text-[1vh] font-medium font-['JetBrains_Mono'] drop-shadow-md leading-tight">
				{currentDate}
			</span>
		</div>
	</div>
</div>