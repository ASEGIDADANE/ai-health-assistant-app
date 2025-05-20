import { Router, Request, Response } from 'express';
import { HealthSnippet, snippets } from '../../constants/healthSnippets';

const router = Router();

function getDayOfYear(): number {
    const now = new Date();
    const start = new Date(now.getFullYear(), 0, 0);
    const diff = now.getTime() - start.getTime();
    const oneDay = 1000 * 60 * 60 * 24;
    return Math.floor(diff / oneDay);
}

router.get('/snippet', (req: Request, res: Response) => {
    if (!snippets || snippets.length === 0) {
        return res.status(500).json({ error: "No health snippets available." });
    }

    const dayOfYear = getDayOfYear();
    
    const snippetIndex = (dayOfYear - 1) % snippets.length;
    const dailySnippet: HealthSnippet = snippets[snippetIndex];

    res.json(dailySnippet);
});


export default router;