# podrazumevano vreme koje protekne na pocetku simulacije je 0ns 
# potrebno podesiti pre pokretanja projekta: 
# settings -> simulation -> simulation -> xsim.simulate.runtime* prozor (tu upisati vrednost)

add_force {/top_tb/redudant_system_instances/module_output[0][8]} -radix bin {1 650ns}
add_force {/top_tb/redudant_system_instances/module_output[0][16]} -radix bin {1 650ns}

add_force {/top_tb/redudant_system_instances/module_output[3][0]} -radix bin {0 710ns}
add_force {/top_tb/redudant_system_instances/module_output[3][2]} -radix bin {0 710ns}

add_force {/top_tb/redudant_system_instances/module_output[1][11]} -radix bin {0 770ns}
add_force {/top_tb/redudant_system_instances/module_output[1][19]} -radix bin {0 770ns}

add_force {/top_tb/redudant_system_instances/module_output[2][23]} -radix bin {1 810ns}
add_force {/top_tb/redudant_system_instances/module_output[2][8]} -radix bin {0 810ns}

add_force {/top_tb/redudant_system_instances/module_output[4][13]} -radix bin {0 850ns}
add_force {/top_tb/redudant_system_instances/module_output[4][11]} -radix bin {1 850ns}

