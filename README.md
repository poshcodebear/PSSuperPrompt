# PSSuperPrompt

Some cool extra tricks for your PowerShell prompt to display more details and colors

## Notes

- Yes, the code is a bit ugly; I've just tweaked with it here and there for a few years and
this is what I've come up with, but I've never taken the time to really make it look "spiffy".
- No, it does not have any configurable options. Sorry. Up until literally the moment I'm writing
this, it has always just run on my machines, so configurability for personal preference was
obviously not on my radar. I would love to add that, though, so if I get around to it, or if
someone likes this starting point and wants to shoot me a pull request with extra bells and
whistles, it may very well get those features in the future.
- The git functions require the modules posh-git and oh-my-posh to be installed. It tests for
oh-my-posh, but not posh-git, so if you just have that installed, the prompt will completely
fail; but if you don't have oh-my-posh, everything but the git functions will work perfectly fine.
    - Yes, this is a bug. I've just been too lazy to fix it since I have both on all my machines ;)
- The Reset-Prompt function (and its alias 'rsp') is really just a way to make mucking with the
prompt easier so I don't have to reload every time I try something, or if I set up another prompt
it lets me switch back to this one with four keystrokes.
- To install it, just paste the entire thing into your `$profile`, or dot source the .ps1 file
from your `$profile`. Either will work.
- If I wind up taking the time, at some point I plan to add a better description and do a lot of the
cleanup and configurability stuff I mentioned above.
    - That said, I know myself too well; please don't hold your breath, as it could happen any time
    between now and the heat death of the universe, and probably closer to the latter than the
    former ;)
- The job control stuff I just added today, so it may or may not be all that great and functional.
I just realized that I should be making better use of jobs, and one of the problems with jobs is
how invisible they are (you have to remember they're there, and they never let you know when they're
done), so the jobs piece is meant to make them more visible.
- Even though I've been using this prompt for years now and it's gone through numerous permutations,
since this is my first public "release" of it, I'll call it v1.0.0
- Fun fact: the original inspiration for this prompt is the Gentoo default prompts (both for root
and for regular users). It still somewhat resembles that prompt, though obviously heavily modified
at this point
